data "aws_caller_identity" "current" {}

locals {
  karpenter_irsa_iam_policy_names_list = ["IAMIntegrationPolicy", "EKSIntegrationPolicy", "InterruptionPolicy", "ZonalShiftPolicy", "ResourceDiscoveryPolicy", "NodeLifecyclePolicy"]
  karpenter_irsa_iam_policy_arns_list = [for policy in local.karpenter_irsa_iam_policy_names_list : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/KarpenterController${policy}-${var.cluster_name}"]
  karpenter_node_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${var.cluster_name}"
}