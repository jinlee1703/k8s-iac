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
