locals {
  prefix = "apne2-${var.terraform_name}"
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "${local.prefix}-tfstate"
    key            = "terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = "${local.prefix}-tfstate-lock"
    encrypt        = true
  }
}
