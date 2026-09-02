output "iam_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.id
}

output "aws_eks_fargate_profile_id" {
  value = aws_eks_fargate_profile.kube-system.id
}

output "cluster_security_group_id" {
  value = data.aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}