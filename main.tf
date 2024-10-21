locals {
  prefix = "apne2-${var.terraform_name}"
}

provider "aws" {
  region = var.aws_region
}
