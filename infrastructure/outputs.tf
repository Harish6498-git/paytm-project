output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "bastion_ip" {
  value = module.bastion.bastion_public_ip
}

