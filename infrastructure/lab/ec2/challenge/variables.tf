variable "name" {
  type        = string
  description = "Name of the resource."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where resource will be created."
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in."
  type        = string
}

variable "ec2_root_block_volume_type" {
  type        = string
  description = "EC2 Root Block Volume type. Default is gp3."
  default     = "gp3"
}

variable "ec2_root_block_volume_size" {
  type        = number
  description = "EC2 Root Block Volume Size in GiB. Defaults to 50."
  default     = 50
}

variable "ec2_ami" {
  type        = string
  description = "ID of AMI to use for the instance."
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = false
}