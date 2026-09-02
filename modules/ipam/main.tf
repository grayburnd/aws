resource "aws_vpc_ipam" "main" {
  description = "Single Region IPAM"
  operating_regions {
    region_name = var.aws_region
  }
}

resource "aws_vpc_ipam_pool" "main-pool" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
  locale         = var.aws_region

}

resource "aws_vpc_ipam_pool_cidr" "main-pool-cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.main-pool.id
  cidr         = var.ipam_pool_cidr
}