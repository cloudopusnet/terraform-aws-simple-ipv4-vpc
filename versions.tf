terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    assert = {
      source  = "hashicorp/assert"
      version = "~> 0.14.0"
    }
  }
}
