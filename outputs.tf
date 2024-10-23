output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "vpc_arn" {
  value       = aws_vpc.main.arn
  description = "Amazon Resource Name (ARN) of VPC"
}

output "internet_gateway_id" {
  value       = length(aws_internet_gateway.main) > 0 ? aws_internet_gateway.main[0].id : null
  description = "The ID of the Internet Gateway"
}

output "internet_gateway_arn" {
  value       = length(aws_internet_gateway.main) > 0 ? aws_internet_gateway.main[0].arn : null
  description = "Amazon Resource Name (ARN) of Internet Gateway"
}