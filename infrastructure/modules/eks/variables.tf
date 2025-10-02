variable "project_name" {
  type        = string
  description = "Prefix for resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC where EKS will run"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets for EKS cluster and node group"
}

variable "key_name" {
  type        = string
  description = "EC2 SSH key pair name for EKS worker nodes"
}

