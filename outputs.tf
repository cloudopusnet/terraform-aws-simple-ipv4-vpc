output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID"
}

output "vpc_arn" {
  value       = aws_vpc.this.arn
  description = "VPC ARN"
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  value       = [for subnet in aws_subnet.private : subnet.id]
  description = "List of public subnet IDs"
}

output "nat_gateway_ipv4_address" {
  value       = var.nat_gateway ? aws_eip.this[0].public_ip : null
  description = "Public IPv4 address of the NAT Gateway"
}
