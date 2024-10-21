variable "prefix" {
  description = "리소스 이름에 사용할 prefix"
  type        = string
}

variable "common_tags" {
  description = "리소스에 적용할 공통 태그"
  type        = map(string)
  default     = {}
}

variable "cidr_block" {
  description = "VPC CIDR 블록"
  type        = string
}

variable "availability_zones" {
  description = "서브넷을 생성할 가용 영역"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}
