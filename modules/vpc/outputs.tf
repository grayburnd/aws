output "private_subnet_ids" {
  value = [for subnet in aws_subnet.priv-subnet : subnet.id]
}
# Produces a map of subnet ids
## {
## "a": "subnet-1234abcd..."
##}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}