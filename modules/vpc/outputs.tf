output "vpc_id" {
  description = "생성된 VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "생성된 Public 서브넷 ID 목록"
  value       = aws_subnet.net[*].id
}

output "private_subnet_ids" {
  description = "생성된 Private 서브넷 ID 목록"
  value       = aws_subnet.app[*].id
}
