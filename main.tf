provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "prod" {
  source         = "./environments/prod"
  terraform_name = var.terraform_name
  vpc_cidr_block = var.vpc_cidr_blocks["prod"]
}
