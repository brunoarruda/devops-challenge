variable "name" {
  type        = string
  description = "Name of the resource."
}
variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "ami" {
  type        = string
  description = "ID of AMI to use for the instance."
}
variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with."
  type        = list(string)
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in."
  type        = string
  default     = null
}

variable "root_block_device" {
  type        = object({
    volume_type = string
    volume_size = string
    tags        = map(string)
  })
  description = "EC2 Root Block device volume type and size."
}

variable "public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}