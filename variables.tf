variable "cidr_block" {
  type        = string
  description = "Valid IPv4 CIDR Range, cannot be set at the same time with ipv4_ipam_pool_id and ipv4_netmask_length"
  nullable    = true
  validation {
    condition     = var.cidr_block != null && provider::assert::cidrv4(var.cidr_block)
    error_message = <<EOF
      The cidr_block must be a valid CIDR range, ideally from the AWS recommended blocks.
      https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
    EOF
  }
}

variable "ipv4_ipam_pool_id" {
  type        = string
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR."
  nullable    = true
  default     = null
}

variable "ipv4_netmask_length" {
  type        = string
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC."
  nullable    = true
  default     = null
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Determines whether the VPC supports assigning public DNS hostnames to instances with public IP addresses."
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "Determines whether the VPC supports DNS resolution through the Amazon provided DNS server."
  default     = true
}

variable "enable_internet_gateway" {
  type        = bool
  description = "Determines whether the VPC has an Internet Gateway associated"
  default     = true
}

variable "context" {
  nullable = true
  type = object({
    context = string
    tags    = map(string)
  })
  default = {
    context = null
    tags    = {}
  }
}
