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

echo "Configuring baremetal minikube pre-requirements"

echo "Disabling AppArmor"
systemctl stop apparmor
systemctl disable apparmor

echo "installing conntrack and crictl packages"
apt-get -q update
apt-get -q -y install conntrack
VERSION="v1.26.0"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz

echo "installing docker"
curl -fsSL https://get.docker.com | bash
usermod -aG docker ubuntu

echo "installing CRI-Dockerd"
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.1/cri-dockerd-0.3.1.amd64.tgz
tar xvf cri-dockerd-0.3.1.amd64.tgz
mv ./cri-dockerd/cri-dockerd /usr/bin/
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
mv cri-docker.socket cri-docker.service /etc/systemd/system/
rm -rf cri-dockerd*

systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket
systemctl status cri-docker.socket

# additional prereq to avoid the following error
# Exiting due to HOST_JUJU_LOCK_PERMISSION: Failed to start host: boot lock: unable to open /tmp/...: permission denied
sysctl fs.protected_regular=0

echo "installing minikube"
curl --silent -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube

echo "starting cluster k8s with docker"
PUBLIC_IP=$(curl --silent http://169.254.169.254/latest/meta-data/public-ipv4)
minikube start --driver=none --cni=calico --apiserver-ips $PUBLIC_IP
echo "@reboot /usr/local/bin/minikube start" | crontab -

echo "provisioning kubeconfig"
LOCAL_IP=$(curl --silent http://169.254.169.254/latest/meta-data/local-ipv4)
su - ubuntu -c "mkdir /home/ubuntu/.kube"
minikube kubectl -- config view --flatten=true --raw > /home/ubuntu/.kube/config
sed -i /home/ubuntu/.kube/config -e "s/$LOCAL_IP/$PUBLIC_IP/"
chown ubuntu:ubuntu /home/ubuntu/.kube/config


echo "installing ingress"
minikube addons enable ingress

echo "installing ArgoCD"
minikube kubectl -- create namespace argocd
minikube kubectl -- apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.6.5/manifests/install.yaml
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