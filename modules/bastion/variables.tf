variable "prefix" {
  description = "리소스 이름에 사용할 prefix"
  type        = string
}

variable "common_tags" {
  description = "리소스에 적용할 공통 태그"
  type        = map(string)
  default     = {}
}

variable "ami_id" {
  description = "Bastion 호스트에 사용할 AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Bastion 호스트 인스턴스 타입"
  type        = string
}

variable "key_name" {
  description = "Bastion 호스트에 사용할 키페어 이름"
  type        = string
}

variable "vpc_id" {
  description = "Bastion 호스트가 속할 VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Bastion 호스트가 속할 서브넷 ID"
  type        = string
}
