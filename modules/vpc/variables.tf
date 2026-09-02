variable "ipam_pool_id" {
  type = string
}

variable "vpc_netmask" {
  type = number
}

variable "private_subnet_netmask_length" {
  type = number
}

variable "opted_availability_zones" {
  type = list(any)
}

variable "aws_region" {
  type        = string
  description = "CIDR for IPAM Pool"
}

variable "public_subnet_netmask_length" {
  type = number
}

variable "ipam_scope_id" {
  type = string
}

variable "cluster_name" {
  type = string
}
