module "simple_vpc" {
  source = "../.."

  tags = {
    Purpose = "test"
  }
}
