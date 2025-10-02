variable "project_name" {
  type        = string
  description = "Prefix for resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for bastion"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets to deploy bastion"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Your public IP in CIDR format (e.g. 1.2.3.4/32)"
}

