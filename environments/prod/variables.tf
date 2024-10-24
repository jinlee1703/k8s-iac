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

variable "api_desired_size" {
  description = "API 서버 노드 그룹의 원하는 크기"
  type        = number
}

variable "api_max_size" {
  description = "API 서버 노드 그룹의 최대 크기"
  type        = number
}

variable "api_min_size" {
  description = "API 서버 노드 그룹의 최소 크기"
  type        = number
}

variable "api_instance_type" {
  description = "API 서버 노드 그룹에 사용할 EC2 인스턴스 유형"
  type        = string
}

variable "api_ami_id" {
  description = "API 서버 노드 그룹에 사용할 AMI ID"
  type        = string
}

variable "api_key_name" {
  description = "API 서버 노드 그룹에 사용할 키페어 이름"
  type        = string
}

variable "db_name" {
  description = "데이터베이스 이름"
  type        = string
}

variable "db_username" {
  description = "데이터베이스 사용자 이름"
  type        = string
}

variable "db_password" {
  description = "데이터베이스 사용자 비밀번호"
  type        = string
}

variable "db_root_password" {
  description = "데이터베이스 root 사용자 비밀번호"
  type        = string
}
