variable "iam_oidc_provider_arn" {
  type = string
}

variable "k8s_namespace" {
  type = string
}

variable "k8s_service_account" {
  type = string
}

variable "irsa_iam_policy_name" {
  type    = string
  default = ""
}

variable "irsa_iam_policy_list" {
  type    = list(string)
  default = []
}

variable "irsa_role_prefix" {
  type = string
}