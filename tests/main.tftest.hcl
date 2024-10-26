provider "aws" {
  region = "eu-central-1"
}

run "validate_vpc" {

  command = plan

  variables {
    context = {
      context    = "CLOUDOPUS-prod"
      tags = {
        Product = "Terraform Module"
      }
    }
    cidr_block = "10.0.0.0/16"
  }

  assert {
    condition     = resource.aws_vpc.main.cidr_block == "10.0.0.0/16"
    error_message = "VPC Resource Error"
  }

  assert {
    condition     = resource.aws_vpc.main.enable_dns_hostnames == true
    error_message = "VPC Resource Error"
  }

  assert {
    condition     = resource.aws_vpc.main.enable_dns_support == true
    error_message = "VPC Resource Error"
  }

  assert {
    condition     = resource.aws_vpc.main.tags.Name == "CLOUDOPUS-prod-vpc"
    error_message = "VPC Resource Error"
  }

  assert {
    condition     = resource.aws_vpc.main.tags.Product == "Terraform Module"
    error_message = "VPC Resource Error"
  }
}
