########################################
# Root Infrastructure - Paytm Project
########################################

# VPC Module
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

# EKS Module
module "eks" {
  source          = "./modules/eks"
  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  key_name        = var.key_name
}

# RDS Module
module "rds" {
  source          = "./modules/rds"
  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

  # ✅ allow EKS worker nodes to connect
  eks_sg_id    = module.eks.node_sg_id
  db_username  = var.db_username
  db_password  = var.db_password
}

# Bastion Host Module
module "bastion" {
  source           = "./modules/bastion"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  public_subnets   = module.vpc.public_subnets
  key_name         = var.key_name
  allowed_ssh_cidr = var.allowed_ssh_cidr
}
