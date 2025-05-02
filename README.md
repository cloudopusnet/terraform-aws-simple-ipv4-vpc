# terraform-aws-simple-ipv4-vpc

Simple AWS VPC for test environments and prototype workloads

# Terraform Docs
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.8 |
| <a name="requirement_assert"></a> [assert](#requirement\_assert) | >=0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.97 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.97 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | Valid IPv4 CIDR Range | `string` | `"10.0.0.0/20"` | no |
| <a name="input_gateway_vpc_endpoints"></a> [gateway\_vpc\_endpoints](#input\_gateway\_vpc\_endpoints) | Enable S3 and DynamoDB Gateway VPC Endpoints | `bool` | `true` | no |
| <a name="input_nat_gateway"></a> [nat\_gateway](#input\_nat\_gateway) | Enable AWS Nat Gateway, set true only if there is at least 1 public subnet | `bool` | `false` | no |
| <a name="input_number_of_private_subnets"></a> [number\_of\_private\_subnets](#input\_number\_of\_private\_subnets) | Number of Private Subnet per AZ to provision. | `number` | `0` | no |
| <a name="input_number_of_public_subnets"></a> [number\_of\_public\_subnets](#input\_number\_of\_public\_subnets) | Number of Public Subnet per AZ to provision. | `number` | `3` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the VPC resources | `map(string)` | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC (Applied as a tag) | `string` | `"terraform-aws-simple-ipv4-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_ipv4_address"></a> [nat\_gateway\_ipv4\_address](#output\_nat\_gateway\_ipv4\_address) | Public IPv4 address of the NAT Gateway |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of public subnet IDs |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of public subnet IDs |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | VPC ARN |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
<!-- END_TF_DOCS -->

# Development workflow
## Setup
- Environment setup is done through [mise](https://mise.jdx.dev)
- All the build dependencies are defined in the `mise.toml` file
