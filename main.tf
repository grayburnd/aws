module "ipam" {
  source         = "./modules/ipam"
  ipam_pool_cidr = var.ipam_pool_cidr
  aws_region     = var.aws_region
}

module "vpc" {
  depends_on                    = [module.ipam]
  cluster_name                  = var.cluster_name
  source                        = "./modules/vpc"
  ipam_pool_id                  = module.ipam.ipam_pool_id
  vpc_netmask                   = var.vpc_netmask
  private_subnet_netmask_length = var.private_subnet_netmask_length
  aws_region                    = var.aws_region
  opted_availability_zones      = var.opted_availability_zones
  public_subnet_netmask_length  = var.public_subnet_netmask_length
  ipam_scope_id                 = module.ipam.ipam_scope_id
}

module "eks" {
  depends_on                       = [module.vpc]
  source                           = "./modules/eks"
  cluster_name                     = var.cluster_name
  private_subnet_ids               = module.vpc.private_subnet_ids
  eks_version                      = var.eks_version
  nodegroup_desired_count          = var.nodegroup_desired_count
  nodegroup_max_count              = var.nodegroup_max_count
  nodegroup_min_count              = var.nodegroup_min_count
  cluster_admin_principal_arn      = var.cluster_admin_principal_arn
  eks_admin_access_policies        = var.eks_admin_access_policies
  addon_vpc_cni_version            = var.addon_vpc_cni_version
  addon_ebs_cni_version            = var.addon_ebs_cni_version
  vpc_cni_irsa_role_arn            = module.irsa_vpc_cni.irsa-role-arn
  aws-ebs-csi-driver_irsa_role_arn = module.irsa_aws-ebs-csi-driver.irsa-role-arn
  environment                      = var.environment
  platform_namespace               = var.platform_namespace
  fargate_pods_policies            = var.fargate_pods_policies
  ec2_pods_policies                = var.ec2_pods_policies
  vpc_cidr                         = module.vpc.vpc_cidr
  vpc_id                           = module.vpc.vpc_id
  karpenter_node_role_arn          = module.karpenter.karpenter_node_role_arn
}

module "irsa_aws-load-balancer-controller" {
  source                = "./modules/irsa"
  iam_oidc_provider_arn = module.eks.iam_oidc_provider_arn
  k8s_service_account   = var.aws-load-balancer-controller_k8s_service_account
  k8s_namespace         = "kube-system"
  irsa_iam_policy_name  = var.aws-load-balancer-controller_irsa_iam_policy_name
  irsa_role_prefix      = "aws-load-balancer-controller"
}

module "irsa_aws-ebs-csi-driver" {
  source                = "./modules/irsa"
  iam_oidc_provider_arn = module.eks.iam_oidc_provider_arn
  k8s_service_account   = var.aws-ebs-csi-driver_k8s_service_account
  k8s_namespace         = "kube-system"
  irsa_iam_policy_name  = var.aws-ebs-csi-driver_irsa_iam_policy_name
  irsa_role_prefix      = "aws-ebs-csi-driver"
}

module "irsa_vpc_cni" {
  source                = "./modules/irsa"
  iam_oidc_provider_arn = module.eks.iam_oidc_provider_arn
  k8s_service_account   = var.vpc_cni_k8s_service_account
  k8s_namespace         = "kube-system"
  irsa_iam_policy_name  = var.vpc_cni_irsa_iam_policy_name
  irsa_role_prefix      = "vpc_cni"
}

module "irsa_postgres_pods" {
  source                = "./modules/irsa"
  iam_oidc_provider_arn = module.eks.iam_oidc_provider_arn
  k8s_service_account   = var.postgres_pods_k8s_service_account
  k8s_namespace         = var.postgres_pods_k8s_namespace
  irsa_iam_policy_name  = var.postgres_pods_irsa_iam_policy_name
  irsa_role_prefix      = "postgres_pods"
}

module "irsa_eso_operator" {
  source                = "./modules/irsa"
  iam_oidc_provider_arn = module.eks.iam_oidc_provider_arn
  k8s_service_account   = var.eso_operator_k8s_service_account
  k8s_namespace         = "kube-system"
  irsa_iam_policy_name  = var.eso_operator_irsa_iam_policy_name
  irsa_role_prefix      = "eso_operator"
}

module "frontend_prod_voting_vote" {
  source                = "./modules/irsa"
  iam_oidc_provider_arn = module.eks.iam_oidc_provider_arn
  k8s_service_account   = var.frontend_prod_voting_vote_k8s_service_account
  k8s_namespace         = var.frontend_prod_voting_vote_k8s_namespace
  irsa_iam_policy_name  = var.frontend_prod_voting_vote_irsa_iam_policy_name
  irsa_role_prefix      = "frontend_prod_voting_vote"
}

module "frontend_prod_voting_results" {
  source                = "./modules/irsa"
  iam_oidc_provider_arn = module.eks.iam_oidc_provider_arn
  k8s_service_account   = var.frontend_prod_voting_results_k8s_service_account
  k8s_namespace         = var.frontend_prod_voting_results_k8s_namespace
  irsa_iam_policy_name  = var.frontend_prod_voting_results_irsa_iam_policy_name
  irsa_role_prefix      = "frontend_prod_voting_results"
}

module "backend_prod_voting_worker" {
  source                = "./modules/irsa"
  iam_oidc_provider_arn = module.eks.iam_oidc_provider_arn
  k8s_service_account   = var.backend_prod_voting_worker_k8s_service_account
  k8s_namespace         = var.backend_prod_voting_worker_k8s_namespace
  irsa_iam_policy_name  = var.backend_prod_voting_worker_irsa_iam_policy_name
  irsa_role_prefix      = "backend_prod_voting_worker"
}

module "postgres_s3_bucket" {
  source             = "./modules/s3"
  application_prefix = "postgres"
}

module "karpenter" {
  source                             = "./modules/karpenter"
  cluster_name                       = var.cluster_name
  karpenter_cloudformation_file_name = var.karpenter_cloudformation_file_name
  vpc_id                             = module.vpc.vpc_id
  vpc_cidr                           = module.vpc.vpc_cidr
}

module "irsa_karpenter_controller" {
  source                = "./modules/irsa"
  iam_oidc_provider_arn = module.eks.iam_oidc_provider_arn
  k8s_service_account   = var.karpenter_k8s_service_account
  k8s_namespace         = "kube-system"
  irsa_iam_policy_list  = module.karpenter.irsa_iam_policy_list
  irsa_role_prefix      = "karpenter_controller"
}

resource "null_resource" "eks_kubeconfig_update" {
  depends_on = [ module.eks.eks_cluster_name ]
  provisioner "local-exec" {
    command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${var.cluster_name}"
  }
}

resource "null_resource" "coredns_rollout_restart" {
  depends_on = [ module.eks.aws_eks_fargate_profile_id, null_resource.eks_kubeconfig_update ]
  provisioner "local-exec" {
    command = "kubectl rollout restart -n kube-system deployments/coredns"
  }
}

# resource "null_resource" "bootstrap_k8s" {
#   depends_on = [ module.eks ]
#   provisioner "local-exec" {
#     command = "cd ~ ; cd GitOps_Project_EKS/infrastructure_repos/terraform/kubernetes ; terraform apply --var-file='/home/grayb_d/GitOps_Project_EKS/infrastructure_repos/terraform/kubernetes/envs/prod.tfvars'"
#   }
# }

# resource "null_resource" "bootstrap_platform" {
#   depends_on = [ module.eks ]
#   provisioner "local-exec" {
#     command = "cd ~ ; cd GitOps_Project_EKS/infrastructure_repos/terraform/kubernetes ; terraform apply --var-file='/home/grayb_d/GitOps_Project_EKS/infrastructure_repos/terraform/kubernetes/envs/prod.tfvars'"
#   }
# }