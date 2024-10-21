resource "aws_instance" "api_master" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.api.id]
  subnet_id              = var.subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.api.name

  tags = {
    Name = "${var.prefix}-api-master"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Kubernetes 마스터 노드 설정
              apt-get update && apt-get install -y apt-transport-https curl
              curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
              echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
              apt-get update
              apt-get install -y kubelet kubeadm kubectl
              apt-mark hold kubelet kubeadm kubectl
              kubeadm init --pod-network-cidr=10.244.0.0/16
              mkdir -p $HOME/.kube
              cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
              chown $(id -u):$(id -g) $HOME/.kube/config
              kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
              EOF
}

resource "aws_instance" "api_workers" {
  count                  = var.desired_size
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.api.id]
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  iam_instance_profile   = aws_iam_instance_profile.api.name

  tags = {
    Name = "${var.prefix}-api-worker-${count.index + 1}"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Kubernetes 워커 노드 설정
              apt-get update && apt-get install -y apt-transport-https curl
              curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
              echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
              apt-get update
              apt-get install -y kubelet kubeadm kubectl
              apt-mark hold kubelet kubeadm kubectl
              # 주의: 실제 환경에서는 동적으로 생성된 토큰과 해시를 사용해야 합니다
              kubeadm join ${aws_instance.api_master.private_ip}:6443 --token <token> --discovery-token-ca-cert-hash <hash>
              EOF
}

resource "aws_iam_role" "api" {
  name = "${var.prefix}-api-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.api.name
}

resource "aws_iam_instance_profile" "api" {
  name = "${var.prefix}-api-profile"
  role = aws_iam_role.api.name
}

resource "aws_security_group" "api" {
  name        = "${var.prefix}-api-sg"
  description = "Security group for API Kubernetes cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-api-sg"
  }
}

resource "aws_lb" "api" {
  name               = "${var.prefix}-api-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.prefix}-api-lb"
  }
}

resource "aws_lb_target_group" "api" {
  name     = "${var.prefix}-api-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/api/health"
    port                = 8080
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.prefix}-api-tg"
  }
}

resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_lb_target_group_attachment" "api_master" {
  target_group_arn = aws_lb_target_group.api.arn
  target_id        = aws_instance.api_master.id
  port             = 8080
}

output "api_endpoint" {
  value = aws_lb.api.dns_name
}

output "kubeconfig_command" {
  value = "aws eks get-token --cluster-name ${var.prefix}-api-cluster | kubectl apply -f -"
}
