module "simple_vpc" {
  source = "../.."

  vpc_name                  = "private-subnets-test"
  number_of_private_subnets = 3
  nat_gateway               = true
  cidr_block                = "10.0.0.0/18"

  tags = {
    Purpose = "private-subnets-test"
  }
}
