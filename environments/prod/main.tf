locals {
  environment = "prod"
  prefix      = "${var.region_code}-${var.terraform_name}-${local.environment}"

  common_tags = {
    Project     = var.terraform_name
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source      = "../../modules/vpc"
  prefix      = local.prefix
  common_tags = local.common_tags
  cidr_block  = var.vpc_cidr_block
}

module "bastion" {
  source        = "../../modules/bastion"
  ami_id        = var.bastion_ami_id
  instance_type = var.bastion_instance_type
  key_name      = var.bastion_key_name
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  prefix        = local.prefix
}
