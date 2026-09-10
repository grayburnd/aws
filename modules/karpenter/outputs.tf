output "karpenter_pods_security_group" {
  value = aws_security_group.karpenter_pods.id
}


