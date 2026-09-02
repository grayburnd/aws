output "ipam_pool_id" {
  description = "IPAM Pool ID"
  value       = aws_vpc_ipam_pool.main-pool.id
}

output "ipam_scope_id" {
  value = aws_vpc_ipam.main.private_default_scope_id
}