variable "ipam_pool_id" {
  type = string
}

variable "vpc_netmask" {
  type = number
}

variable "opted_availability_zones" {
  type = list(any)
}

variable "aws_region" {
  type        = string
  description = "CIDR for IPAM Pool"
}

