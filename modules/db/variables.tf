variable "prefix" {
  description = "리소스 이름에 사용될 접두사"
  type        = string
}

variable "db_replicas" {
  description = "데이터베이스 복제본 수"
  type        = number
  default     = 1
}

variable "db_root_password" {
  description = "MySQL root 비밀번호"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "MySQL 사용자 이름"
  type        = string
}

variable "db_password" {
  description = "MySQL 사용자 비밀번호"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "생성할 데이터베이스 이름"
  type        = string
}

variable "storage_size" {
  description = "영구 볼륨 클레임의 크기"
  type        = string
  default     = "10Gi"
}

variable "mysql_version" {
  description = "사용할 MySQL 버전"
  type        = string
  default     = "5.7"
}

variable "namespace" {
  description = "배포할 Kubernetes 네임스페이스"
  type        = string
  default     = "default"
}

variable "node_selector" {
  description = "데이터베이스 파드를 배치할 노드 선택기"
  type        = map(string)
  default     = {}
}

variable "resource_requests" {
  description = "데이터베이스 파드의 리소스 요청"
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "100m"
    memory = "256Mi"
  }
}

variable "resource_limits" {
  description = "데이터베이스 파드의 리소스 제한"
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "500m"
    memory = "512Mi"
  }
}
