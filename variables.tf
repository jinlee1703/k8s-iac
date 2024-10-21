variable "aws_region" {
  description = "리소스를 생성할 AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "terraform_name" {
  description = "서비스 이름"
  type        = string
  default     = "k8s"
}
