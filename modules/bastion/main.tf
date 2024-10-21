resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-bastion"
    }
  )
}

resource "aws_security_group" "bastion" {
  name   = "${var.prefix}-bastion-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.this.private_key_pem
  filename        = "${var.key_name}.pem"
  file_permission = "0600"
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-bastion-eip"
    }
  )
}

