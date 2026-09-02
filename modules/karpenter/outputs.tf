output "irsa_iam_policy_list" {
  description = "List of IAM Policies for Karpenter IRSA IAM Role"
  value       = tolist([aws_cloudformation_stack.karpenter.outputs["IAMIntegrationPolicyARN"], aws_cloudformation_stack.karpenter.outputs["IAMEKSIntegrationPolicyARN"], aws_cloudformation_stack.karpenter.outputs["IAMInterruptionPolicyARN"], aws_cloudformation_stack.karpenter.outputs["IAMZonalShiftPolicyARN"], aws_cloudformation_stack.karpenter.outputs["IAMResourceDiscoveryPolicyARN"], aws_cloudformation_stack.karpenter.outputs["IAMNodeLifecyclePolicyARN"]])
}

output "karpenter_pods_security_group" {
  value = aws_security_group.karpenter_pods.id
}

output "karpenter_node_role_arn" {
  value = aws_cloudformation_stack.karpenter.outputs["KarpenterNodeRoleARN"]
}



