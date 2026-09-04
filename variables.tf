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

variable "private_subnet_netmask_length" {
  type = number
}

variable "opted_availability_zones" {
  type = list(any)
}

variable "public_subnet_netmask_length" {
  type = number
}

variable "eks_version" {
  type = string
}

variable "nodegroup_desired_count" {
  type = number
}

variable "nodegroup_min_count" {
  type = number
}

variable "nodegroup_max_count" {
  type = number
}

variable "cluster_admin_principal_arn" {
  type = string
}

variable "eks_admin_access_policies" {
  type = list(any)
}

variable "addon_vpc_cni_version" {
  type = string
}

variable "addon_ebs_cni_version" {
  type = string
}

variable "fargate_pods_policies" {
  type = list(string)
}

variable "ec2_pods_policies" {
  type = list(string)
}

variable "aws-load-balancer-controller_k8s_namespace" {
  type = string
}

variable "aws-load-balancer-controller_k8s_service_account" {
  type = string
}

variable "aws-ebs-csi-driver_k8s_namespace" {
  type = string
}

variable "aws-ebs-csi-driver_k8s_service_account" {
  type = string
}

variable "vpc_cni_k8s_namespace" {
  type = string
}

variable "vpc_cni_k8s_service_account" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "aws-load-balancer-controller_irsa_iam_policy_name" {
  type = string
}

variable "aws-ebs-csi-driver_irsa_iam_policy_name" {
  type = string
}

variable "vpc_cni_irsa_iam_policy_name" {
  type = string
}

variable "postgres_pods_k8s_namespace" {
  type = string
}

variable "postgres_pods_k8s_service_account" {
  type = string
}

variable "postgres_pods_irsa_iam_policy_name" {
  type = string
}

variable "eso_operator_k8s_namespace" {
  type = string
}

variable "eso_operator_k8s_service_account" {
  type = string
}

variable "eso_operator_irsa_iam_policy_name" {
  type = string
}

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

variable "environment" {
  type = string
}

variable "fargate_profile_candidates" {
  type = list(string)
}

variable "platform_namespace" {
  type = string
}

variable "karpenter_cloudformation_file_name" {
  type = string
}

variable "karpenter_k8s_service_account" {
  type = string
}

variable "amazon-cloudwatch-observability_k8s_service_account" {
  type = string
}

variable "amazon-cloudwatch-observability_irsa_iam_policy_name" {
  type = string
}