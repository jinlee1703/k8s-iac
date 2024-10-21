provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "prod" {
  source                = "./environments/prod"
  terraform_name        = var.terraform_name
  vpc_cidr_block        = var.vpc_cidr_blocks["prod"]
  bastion_ami_id        = var.bastion["ami_id"]
  bastion_instance_type = var.bastion["instance_type"]
  bastion_key_name      = var.bastion["key_name"]
}
