data "aws_caller_identity" "current" {}

resource "aws_kms_key" "k8s_secrets" {
  description              = "K8s secrets encryption key"
  enable_key_rotation      = true
  deletion_window_in_days  = 10
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
}

resource "aws_kms_key_policy" "k8s_secrets_policy" {
  key_id = aws_kms_key.k8s_secrets.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  }) ##overly permissive due to proj
}

resource "aws_eks_cluster" "main" {
  name = var.cluster_name

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.k8s_secrets.arn
    }
  }

  access_config {
    authentication_mode = "API"
  }

  deletion_protection = false

  role_arn = aws_iam_role.cluster.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

data "aws_eks_cluster" "main" {
  name = aws_eks_cluster.main.name
}

resource "aws_vpc_security_group_ingress_rule" "cluster_ingress" {
  security_group_id = data.aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = -1
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]
}

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}


##Access Entry

resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.cluster_admin_principal_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_admin" {
  for_each      = toset(var.eks_admin_access_policies)
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = each.value
  principal_arn = var.cluster_admin_principal_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_entry" "github_actions" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.github_oidc_principal_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_actions" {
  for_each      = toset(var.eks_admin_access_policies)
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = each.value
  principal_arn = var.github_oidc_principal_arn

  access_scope {
    type = "cluster"
  }
}

##https://github.com/aws/karpenter-provider-aws/issues/5369
resource "aws_eks_access_entry" "karpenter_node" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.karpenter_node_role_arn
  type          = "EC2_LINUX"
  # kubernetes_groups = ["system:bootstrappers", "system:nodes"]
}

##Fargate Profile

resource "aws_iam_role" "fargate_pods" {
  name = "fargate_pods"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_pods_" {
  for_each   = toset(var.fargate_pods_policies)
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
  role       = aws_iam_role.fargate_pods.name
}

#Ec2 pods

resource "aws_iam_role" "ec2_pods" {
  name = "ec2_pods"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_pods" {
  for_each   = toset(var.ec2_pods_policies)
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
  role       = aws_iam_role.fargate_pods.name
}

resource "aws_iam_role_policy_attachment" "ec2_pods_custom" {
  for_each   = toset(var.ec2_pods_policies)
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
  role       = aws_iam_role.fargate_pods.name
}

resource "aws_eks_fargate_profile" "kube-system" {
  depends_on             = [aws_eks_cluster.main]
  cluster_name           = var.cluster_name
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.fargate_pods.arn
  subnet_ids             = var.private_subnet_ids

  selector {
    namespace = "kube-system"
  }
}

##Add-on

resource "aws_eks_addon" "vpc_cni" {
  depends_on               = [aws_eks_fargate_profile.kube-system]
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "vpc-cni"
  addon_version            = var.addon_vpc_cni_version ##Parameterise after
  service_account_role_arn = var.vpc_cni_irsa_role_arn

  configuration_values = jsonencode({
    env = {
      ENABLE_PREFIX_DELEGATION = "true"
      WARM_PREFIX_TARGET       = "1"
    }
  })
}

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  depends_on               = [aws_eks_fargate_profile.kube-system]
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.addon_ebs_cni_version ##Parameterise after
  service_account_role_arn = var.aws-ebs-csi-driver_irsa_role_arn
}

resource "aws_eks_addon" "amazon-cloudwatch-observability" {
  depends_on               = [aws_eks_fargate_profile.kube-system]
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "amazon-cloudwatch-observability"
  addon_version            = var.addon_amazon_cloudwatch_observability_version
  service_account_role_arn = var.amazon-cloudwatch-observability_irsa_role_arn
  namespace_config {
    namespace = "kube-system"
  }
}

resource "aws_eks_addon" "metrics-server" {
  depends_on    = [aws_eks_fargate_profile.kube-system]
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "metrics-server"
  addon_version = var.addon_metrics_server_version ##Parameterise after
}






