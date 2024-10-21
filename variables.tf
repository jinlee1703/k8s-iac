variable "aws_region" {
  description = "리소스를 생성할 AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "terraform_name" {
  description = "서비스 이름"
  type        = string
  default     = "k8s"
}

variable "vpc_cidr_blocks" {
  description = "VPC CIDR 블록"
  type        = map(string)
}
