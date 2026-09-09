
variable "aws_region" {
  type        = string
  description = "Region for VPC Deployment"
}

variable "ipam_pool_cidr" {
  type        = string
  description = "CIDR for IPAM Pool"
}

variable "vpc_netmask" {
  type = number
}

variable "opted_availability_zones" {
  type = list(any)
}

variable "cluster_name" {
  type = string
}

variable "eks_version" {
  type = string
}

variable "cluster_admin_principal_arn" {
  type = string
}

variable "github_oidc_principal_arn" {
  type = string
}

variable "eks_admin_access_policies" {
  type = list(string)
}

variable "addon_vpc_cni_version" {
  type = string
}

variable "addon_ebs_cni_version" {
  type = string
}

variable "addon_amazon_cloudwatch_observability_version" {
  type = string
}

variable "addon_metrics_server_version" {
  type = string
}

variable "fargate_pods_policies" {
  type = list(string)
}

variable "ec2_pods_policies" {
  type = list(string)
}

variable "aws_load_balancer_controller_k8s_service_account" {
  type = string
}

variable "aws_load_balancer_controller_irsa_iam_policy_name" {
  type = string
}

variable "aws_ebs_csi_driver_k8s_service_account" {
  type = string
}

variable "aws_ebs_csi_driver_irsa_iam_policy_name" {
  type = string
}

variable "vpc_cni_k8s_service_account" {
  type = string
}

variable "vpc_cni_irsa_iam_policy_name" {
  type = string
}

#https://postgres-operator.readthedocs.io/en/latest/
variable "postgres_pods_k8s_namespace" {
  type = string
}

variable "postgres_pods_k8s_service_account" {
  type = string
}

variable "postgres_pods_irsa_iam_policy_name" {
  type = string
}

variable "eso_operator_k8s_service_account" {
  type = string
}

variable "eso_operator_irsa_iam_policy_name" {
  type = string
}

#voting app 
variable "frontend_prod_voting_vote_k8s_namespace" {
  type = string
}

variable "frontend_prod_voting_vote_k8s_service_account" {
  type = string
}

variable "frontend_prod_voting_vote_irsa_iam_policy_name" {
  type = string
}

variable "frontend_prod_voting_results_k8s_namespace" {
  type = string
}

variable "frontend_prod_voting_results_k8s_service_account" {
  type = string
}

variable "frontend_prod_voting_results_irsa_iam_policy_name" {
  type = string
}

variable "backend_prod_voting_worker_k8s_namespace" {
  type = string
}

variable "backend_prod_voting_worker_k8s_service_account" {
  type = string
}

variable "backend_prod_voting_worker_irsa_iam_policy_name" {
  type = string
}

#https://karpenter.sh/
variable "karpenter_k8s_service_account" {
  type = string
}
#Note: Karpenter uses iam policies output from the TF-managed Karpenter bootstrap CFN Stack

#https://docs.aws.amazon.com/eks/latest/userguide/workloads-add-ons-available-eks.html#amazon-cloudwatch-observability
variable "amazon_cloudwatch_observability_k8s_service_account" {
  type = string
}

variable "amazon_cloudwatch_observability_irsa_iam_policy_name" {
  type = string
}

#IRSA
######

variable "karpenter_cloudformation_file_name" {
  type = string
}

variable "argocd_chart_version" {
  type = string
}

variable "argocd_namespace" {
  type = string
}

variable "namespace_list" {
  type = list(string)
}