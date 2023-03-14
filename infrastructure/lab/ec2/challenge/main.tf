terraform {
  required_version = ">= 1.3.7"
  backend "s3" {
    bucket  = "brunoarruda-tfstate"
    key     = "lab/ec2/challenge/terraform.tfstate"
    region  = "us-east-1"
  }
}

locals {
  user_data = <<EOF
#!/bin/bash
echo "user_data script!"
echo "installing podman"
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl --silent -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/Release.key" | sudo apt-key add -
apt-get -qq update
apt-get -qq -y install podman

echo "installing minikube"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64s

PUBLIC_IP=$(curl --silent http://169.254.169.254/latest/meta-data/public-ipv4)
su - ubuntu -c "minikube start --driver=podman --container-runtime=cri-o --listen-address=0.0.0.0 --embed-certs"

su - ubuntu -c "minikube kubectl -- create namespace argocd"
su - ubuntu -c "minikube kubectl -- apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
EOF
}

module "ec2" {
    source = "../../../../module/ec2"
    name = var.name
    ami = var.ec2_ami
    instance_type = var.instance_type

    user_data = local.user_data

    public_ip_address = var.public_ip_address
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.minikube.id]

    root_block_device = {
      volume_type = var.ec2_root_block_volume_type
      volume_size = var.ec2_root_block_volume_size
      tags = null
    }
}