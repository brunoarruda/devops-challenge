output "id" {
  description = "ID of EC2 instance"
  value = module.ec2.id
}

output "public_ip" {
  description = "Public IP of EC2 instance"
  value = module.ec2.public_ip
}
