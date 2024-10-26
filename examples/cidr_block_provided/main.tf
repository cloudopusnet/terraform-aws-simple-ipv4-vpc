module "vpc" {
  source = "../../"

  cidr_block = "10.0.0.0/16"
  context = {
    context = "cloudopus-prod"
    tags = {
      product = "best"
    }
  }
}
