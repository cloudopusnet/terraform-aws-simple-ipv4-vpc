data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

locals {
  azs           = slice(data.aws_availability_zones.available.names, 0, 3)
  total_subnets = var.number_of_public_subnets + var.number_of_private_subnets
  subnet_cidrs = [
    for i in range(local.total_subnets) :
    cidrsubnet(var.cidr_block, 4, i)
  ]
  public_subnets = [
    for i in range(var.number_of_public_subnets) : {
      name = "public-${i}"
      cidr = local.subnet_cidrs[i]
      az   = local.azs[i % length(local.azs)]
      tags = merge(var.tags, { Name = "${var.vpc_name}-public-${i}", VpcName = var.vpc_name })
    }
  ]
  private_subnets = [
    for i in range(var.number_of_private_subnets) : {
      name = "private-${i}"
      cidr = local.subnet_cidrs[i + var.number_of_public_subnets]
      az   = local.azs[i % length(local.azs)]
      tags = merge(var.tags, { Name = "${var.vpc_name}-private-${i}", VpcName = var.vpc_name })
    }
  ]
  vpc_tags                 = merge(var.tags, { Name = var.vpc_name })
  igw_tags                 = merge(var.tags, { Name = "terraform-aws-simple-ipv4-vpc-igw" })
  public_route_table_tags  = merge(var.tags, { Name = "terraform-aws-simple-ipv4-vpc-public-rt" })
  private_route_table_tags = merge(var.tags, { Name = "terraform-aws-simple-ipv4-vpc-private-rt" })
  eip_tags                 = merge(var.tags, { Name = "terraform-aws-simple-ipv4-vpc-nat-eip" })
  nat_tags                 = merge(var.tags, { Name = "terraform-aws-simple-ipv4-vpc-nat" })
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = local.vpc_tags
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = local.igw_tags
}

resource "aws_subnet" "public" {
  for_each = { for subnet in local.public_subnets : subnet.name => subnet }

  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = false
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  tags                    = each.value.tags
}

resource "aws_subnet" "private" {
  for_each = { for subnet in local.private_subnets : subnet.name => subnet }

  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = false
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  tags                    = each.value.tags
}

resource "aws_route_table" "public" {
  count  = var.number_of_public_subnets > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = local.public_route_table_tags
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  route_table_id = aws_route_table.public[0].id
  subnet_id      = each.value.id
}

resource "aws_eip" "this" {
  count = var.nat_gateway ? 1 : 0

  domain = "vpc"
  tags   = local.eip_tags
}

resource "aws_nat_gateway" "this" {
  count = var.nat_gateway ? 1 : 0

  allocation_id = aws_eip.this[0].allocation_id
  subnet_id     = aws_subnet.public["public-0"].id
  tags          = local.nat_tags
  depends_on    = [aws_eip.this]
}

resource "aws_route_table" "private" {
  count = var.number_of_private_subnets > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[0].id
    }
  }

  tags = local.private_route_table_tags
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  route_table_id = aws_route_table.private[0].id
  subnet_id      = each.value.id
}

resource "aws_vpc_endpoint" "s3" {
  count = var.gateway_vpc_endpoints ? 1 : 0

  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = concat(
    var.number_of_public_subnets > 0 ? [aws_route_table.public[0].id] : [],
    var.number_of_private_subnets > 0 ? [aws_route_table.private[0].id] : []
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.gateway_vpc_endpoints ? 1 : 0

  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  route_table_ids = concat(
    var.number_of_public_subnets > 0 ? [aws_route_table.public[0].id] : [],
    var.number_of_private_subnets > 0 ? [aws_route_table.private[0].id] : []
  )
}
