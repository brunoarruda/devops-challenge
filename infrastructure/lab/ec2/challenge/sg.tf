resource "aws_security_group" "minikube" {
  name        = "minikube-challenge"
  description = "security group for minikube-challenge."
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Terraform = "true"
    Environment = "lab"
  }
}

resource "aws_security_group_rule" "access_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.minikube.id
  description              = "SSH access"
}

resource "aws_security_group_rule" "access_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.minikube.id
  description              = "HTTP access"
}

resource "aws_security_group_rule" "access_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.minikube.id
  description              = "HTTPS access"
}

resource "aws_security_group_rule" "access_k8s_api" {
  type                     = "ingress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "TCP"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.minikube.id
  description              = "Kubernetes API access"
}