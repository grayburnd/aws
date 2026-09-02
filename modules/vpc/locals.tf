locals {
  subnet_cidrs         = cidrsubnets(aws_vpc.main.cidr_block, 1, 2)
  private_subnet_cidrs = cidrsubnets(local.subnet_cidrs[0], 2, 2, 2)
  public_subnet_cidrs  = cidrsubnets(local.subnet_cidrs[1], 2, 2, 2)
}