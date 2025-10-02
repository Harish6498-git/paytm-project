variable "project_name" {
  type        = string
  description = "Prefix for resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where RDS will be created"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets for RDS subnet group"
}

variable "eks_sg_id" {
  type        = string
  description = "Security group ID of EKS worker nodes that can access RDS"
}


variable "db_username" {
  type        = string
  description = "Database master username"
}

variable "db_password" {
  type        = string
  description = "Database master password"
  sensitive   = true
}

