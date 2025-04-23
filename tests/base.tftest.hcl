provider "aws" {
  region = "eu-central-1"
}

run "defaults" {

  command = plan

  assert {
    condition     = aws_vpc.this.tags["Name"] == "terraform-aws-simple-ipv4-vpc"
    error_message = "Defaults are not properly applied, name should be VPC Name should be terraform-aws-simple-ipv4-vpc"
  }

  assert {
    condition     = aws_vpc.this.cidr_block == "10.0.0.0/20"
    error_message = "Defaults are not properly applied, name should be VPC Cidr Block should be 10.0.0.0/20"
  }

  assert {
    condition     = length(aws_subnet.public) == 3
    error_message = "Defaults are not properly applied, expected exactly 3 public subnets"
  }

  assert {
    condition     = length(aws_subnet.private) == 0
    error_message = "Defaults are not properly applied, expected exactly 0 private subnets"
  }
}

run "complex" {

  command = plan

  variables {
    cidr_block                = "10.0.0.0/16"
    vpc_name                  = "test-it"
    number_of_public_subnets  = 2
    number_of_private_subnets = 2
    nat_gateway               = true
    gateway_vpc_endpoints     = false
    tags = {
      Environment = "test-it"
    }

  }

  assert {
    condition     = aws_vpc.this.tags["Name"] == "test-it"
    error_message = "Variables are not properly applied, name should be VPC Name should be test-it"
  }

  assert {
    condition     = aws_vpc.this.tags["Environment"] == "test-it"
    error_message = "Variables are not properly applied, name should be VPC Name should be test-it"
  }

  assert {
    condition     = aws_vpc.this.cidr_block == "10.0.0.0/16"
    error_message = "Variables are not properly applied, name should be VPC Cidr Block should be 10.0.0.0/16"
  }

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Variables are not properly applied, expected exactly 2 public subnets"
  }

  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "Variables are not properly applied, expected exactly 2 private subnets"
  }

  assert {
    condition     = length(aws_nat_gateway.this) == 1
    error_message = "Variables are not properly applied, NAT Gateway should exists"
  }

  assert {
    condition     = length(aws_vpc_endpoint.s3) == 0
    error_message = "Variables are not properly applied, S3 Endpoint should not exist"
  }
}

run "private" {

  command = plan

  variables {
    number_of_public_subnets  = 0
    number_of_private_subnets = 3
    nat_gateway               = false
  }

  assert {
    condition     = aws_vpc.this.cidr_block == "10.0.0.0/20"
    error_message = "Defaults are not properly applied, name should be VPC Cidr Block should be 10.0.0.0/16"
  }

  assert {
    condition     = length(aws_subnet.public) == 0
    error_message = "Variables are not properly applied, expected exactly 2 public subnets"
  }

  assert {
    condition     = length(aws_subnet.private) == 3
    error_message = "Variables are not properly applied, expected exactly 2 private subnets"
  }

  assert {
    condition     = length(aws_nat_gateway.this) == 0
    error_message = "Variables are not properly applied, NAT Gateway should exists"
  }
}
