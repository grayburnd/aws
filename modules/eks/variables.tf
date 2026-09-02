variable "private_subnet_ids" {
  type = list(string)
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

variable "cluster_name" {
  type = string
}

variable "aws-ebs-csi-driver_irsa_role_arn" {
  type = string
}

variable "vpc_cni_irsa_role_arn" {
  type = string
}

variable "platform_namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "fargate_pods_policies" {
  type = list(string)
}

variable "ec2_pods_policies" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "karpenter_node_role_arn" {
  type = string
}