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
  api_desired_size      = var.api["desired_size"]
  api_max_size          = var.api["max_size"]
  api_min_size          = var.api["min_size"]
  api_instance_type     = var.api["instance_type"]
  api_ami_id            = var.api["ami_id"]
  api_key_name          = var.api["key_name"]
}
