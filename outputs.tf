output "vpc-id" {
  value = "${module.vpc.vpc_id} ... Put this in the Load Balancer Controller"
}

output "cluster_security_group_id" {
  value = "${module.eks.cluster_security_group_id}... Put this in the Karpenter NodePool/Classes for each Team"
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}