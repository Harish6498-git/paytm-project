variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "project_name" {
  description = "Prefix for all resources"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name for bastion host"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Your IP allowed to SSH into bastion (example: 1.2.3.4/32)"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

