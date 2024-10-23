locals {
  cidr_block          = (var.cidr_block != null && var.ipv4_ipam_pool_id == null && var.ipv4_netmask_length == null) ? var.cidr_block : null
  ipv4_ipam_pool_id   = (var.cidr_block == null && var.ipv4_ipam_pool_id != null && var.ipv4_netmask_length != null) ? var.ipv4_ipam_pool_id : null
  ipv4_netmask_length = (var.cidr_block == null && var.ipv4_netmask_length != null && var.ipv4_ipam_pool_id != null) ? var.ipv4_netmask_length : null
}

resource "aws_vpc" "main" {
  cidr_block           = local.cidr_block
  ipv4_ipam_pool_id    = local.ipv4_ipam_pool_id
  ipv4_netmask_length  = local.ipv4_netmask_length
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
}

resource "aws_internet_gateway" "main" {
  count = var.enable_internet_gateway == true ? 1 : 0

  vpc_id = aws_vpc.main.id
}
