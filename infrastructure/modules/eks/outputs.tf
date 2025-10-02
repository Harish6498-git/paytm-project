output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "node_sg_id" {
  value       = aws_security_group.eks_nodes.id
  description = "Security Group ID for EKS worker nodes"
}



