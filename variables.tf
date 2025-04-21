variable "cidr_block" {
  type        = string
  description = "Valid IPv4 CIDR Range"
  default     = "10.0.0.0/20"
  validation {
    condition     = provider::assert::cidrv4(var.cidr_block)
    error_message = <<EOF
      The cidr_block must be a valid CIDR range, ideally from the AWS recommended blocks.
      https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
    EOF
  }
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC (Applied as a tag)"
  default     = "terraform-aws-simple-ipv4-vpc"
}

variable "number_of_public_subnets" {
  type        = number
  description = "Number of Public Subnet per AZ to provision."
  default     = 3
  validation {
    condition     = var.number_of_public_subnets <= 3
    error_message = "number_of_public_subnets should be smaller or equal to 3"
  }
}

variable "number_of_private_subnets" {
  type        = number
  description = "Number of Private Subnet per AZ to provision."
  default     = 0
  validation {
    condition     = var.number_of_private_subnets <= 3
    error_message = "number_of_public_subnets should be smaller or equal to 3"
  }
}

variable "nat_gateway" {
  type        = bool
  description = "Enable AWS Nat Gateway, set true only if there is at least 1 public subnet"
  default     = false
}

variable "gateway_vpc_endpoints" {
  type        = bool
  description = "Enable S3 and DynamoDB Gateway VPC Endpoints"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the VPC resources"
  default     = {}
}
