terraform {
  required_version = ">= 1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.97"
    }
    assert = {
      source  = "hashicorp/assert"
      version = ">=0.15.0"
    }
  }
}
