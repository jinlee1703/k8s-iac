variable "terraform_name" {
  description = "서비스 이름"
  type        = string
}

variable "aws_region" {
  description = "리소스를 생성할 AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "region_code" {
  description = "AWS 리전 코드"
  type        = string
  default     = "apne2"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  type        = string
}

variable "bastion_ami_id" {
  description = "Bastion 호스트에 사용할 AMI ID"
  type        = string
}

variable "bastion_instance_type" {
  description = "Bastion 호스트 인스턴스 타입"
  type        = string
}

variable "bastion_key_name" {
  description = "Bastion 호스트에 사용할 키페어 이름"
  type        = string
}
