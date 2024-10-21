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

variable "bastion" {
  description = "Bastion 호스트 설정"
  type = object({
    ami_id        = string
    instance_type = string
    key_name      = string
  })
}

variable "api" {
  description = "API 서버 설정"
  type = object({
    desired_size   = number
    max_size       = number
    min_size       = number
    instance_types = list(string)
  })
}
