terraform {
  required_version = ">= 1.3.7"
  backend "s3" {
    bucket  = "brunoarruda-tfstate"
    key     = "lab/ec2/challenge/terraform.tfstate"
    region  = "us-east-1"
  }
}

module "ec2" {
    source = "../../../../module/ec2"
    name = var.name
    ami = var.ec2_ami
    instance_type = var.instance_type

    public_ip_address = var.public_ip_address
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.minikube.id]

    root_block_device = {
      volume_type = var.ec2_root_block_volume_type
      volume_size = var.ec2_root_block_volume_size
      tags = null
    }
}