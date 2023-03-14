provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"

  name                    = var.name
  instance_type           = var.instance_type
  ami                     = var.ami
  root_block_device       = [var.root_block_device]

  key_name  = var.name
  user_data = var.user_data

  vpc_security_group_ids  = var.vpc_security_group_ids
  subnet_id               = var.subnet_id
  associate_public_ip_address = var.public_ip_address

  monitoring = false

  tags = {
    Provisioned = "terraform"
    Environment = "lab"
  }
}