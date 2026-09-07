environment                   = "prod"
platform_namespace            = "platform"
aws_region                    = "us-east-1"
ipam_pool_cidr                = "10.0.0.0/10"
vpc_netmask                   = 20
opted_availability_zones      = ["a", "b"]
public_subnet_netmask_length  = 25
eks_version                   = "1.36"
nodegroup_desired_count       = 4
nodegroup_max_count           = 4
nodegroup_min_count           = 4
cluster_admin_principal_arn   = "arn:aws:iam::632988741882:user/admin"
eks_admin_access_policies     = ["arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy", "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"]
addon_vpc_cni_version         = "v1.22.3-eksbuild.1"
addon_ebs_cni_version         = "v1.63.1-eksbuild.1"
fargate_pods_policies         = ["AmazonEKSFargatePodExecutionRolePolicy", "AmazonEKSWorkerNodePolicy", "AmazonElasticContainerRegistryPublicReadOnly", "CloudWatchLogsFullAccess"]
ec2_pods_policies             = ["AmazonEKSWorkerNodePolicy", "AmazonElasticContainerRegistryPublicReadOnly", "AmazonSSMManagedInstanceCore"]
cluster_name                  = "main-eks-cluster"

aws-load-balancer-controller_k8s_service_account  = "aws-load-balancer-controller-sa"
aws-load-balancer-controller_irsa_iam_policy_name = "lbc-policy.json"

aws-ebs-csi-driver_k8s_service_account  = "ebs-csi-controller-sa"
aws-ebs-csi-driver_irsa_iam_policy_name = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"

vpc_cni_k8s_namespace        = "kube-system"
vpc_cni_k8s_service_account  = "aws-node"
vpc_cni_irsa_iam_policy_name = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

postgres_pods_k8s_namespace        = "postgres"
postgres_pods_k8s_service_account  = "postgres-pods-sa"
postgres_pods_irsa_iam_policy_name = "arn:aws:iam::aws:policy/AmazonS3FullAccess"

eso_operator_k8s_namespace        = "platform-prod"
eso_operator_k8s_service_account  = "external-secrets-sa"
eso_operator_irsa_iam_policy_name = "eso_operator_policy.json"

frontend_prod_voting_vote_k8s_namespace           = "frontend-prod"
frontend_prod_voting_vote_k8s_service_account     = "voting-vote-sa"
frontend_prod_voting_vote_irsa_iam_policy_name    = "arn:aws:iam::aws:policy/AWSSecretsManagerClientReadOnlyAccess"
frontend_prod_voting_results_k8s_namespace        = "frontend-prod"
frontend_prod_voting_results_k8s_service_account  = "voting-results-sa"
frontend_prod_voting_results_irsa_iam_policy_name = "arn:aws:iam::aws:policy/AWSSecretsManagerClientReadOnlyAccess"

backend_prod_voting_worker_k8s_namespace        = "backend-prod"
backend_prod_voting_worker_k8s_service_account  = "voting-worker-sa"
backend_prod_voting_worker_irsa_iam_policy_name = "arn:aws:iam::aws:policy/AWSSecretsManagerClientReadOnlyAccess"

fargate_profile_candidates = ["aws-load-balancer-controller", "redis-operator", "postgres-operator", "eso-operator", "kube-prometheus-stack", "metrics-server", "vpa", "karpenter"]

karpenter_cloudformation_file_name = "karpenter-cloudformation.yaml"

karpenter_k8s_service_account = "karpenter-controller-sa"

amazon-cloudwatch-observability_k8s_service_account  = "cloudwatch-agent"
amazon-cloudwatch-observability_irsa_iam_policy_name = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"