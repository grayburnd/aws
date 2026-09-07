resource "aws_cloudformation_stack" "karpenter" {
  name          = "karpenter-stack"
  capabilities  = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  template_body = file("${path.root}/templates/cloudformation/${var.karpenter_cloudformation_file_name}")
  parameters = {
    ClusterName = var.cluster_name
  }
}

resource "aws_security_group" "karpenter_pods" {
  name        = "karpenter_pods"
  description = "Allows local VPC traffic"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "karpenter_pods_ingress" {
  security_group_id = aws_security_group.karpenter_pods.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = -1
}

resource "aws_vpc_security_group_egress_rule" "karpenter_pods_egress" {
  security_group_id = aws_security_group.karpenter_pods.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}