variable "prefix" {
  description = "리소스 이름에 사용할 접두사"
  type        = string
}

variable "subnet_ids" {
  description = "EKS 클러스터를 생성할 서브넷 ID 목록"
  type        = list(string)
}

variable "desired_size" {
  description = "노드 그룹의 원하는 크기"
  type        = number
}

variable "max_size" {
  description = "노드 그룹의 최대 크기"
  type        = number
}

variable "min_size" {
  description = "노드 그룹의 최소 크기"
  type        = number
}

variable "instance_types" {
  description = "노드 그룹에 사용할 EC2 인스턴스 유형 목록"
  type        = list(string)
}

variable "vpc_id" {
  description = "EKS 클러스터를 생성할 VPC ID"
  type        = string
}

variable "common_tags" {
  description = "리소스에 적용할 공통 태그 목록"
  type        = map(string)
}
