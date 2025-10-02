# ---------------------------
# IAM Role for EKS Cluster
# ---------------------------
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ---------------------------
# IAM Role for Node Group
# ---------------------------
resource "aws_iam_role" "eks_node_role" {
  name = "${var.project_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# ---------------------------
# EKS Cluster
# ---------------------------
resource "aws_eks_cluster" "cluster" {
  name     = "${var.project_name}-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.29"

  vpc_config {
    subnet_ids = var.private_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
  ]
}

# Security group for worker nodes
resource "aws_security_group" "eks_nodes" {
  name        = "${var.project_name}-eks-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-eks-nodes-sg"
  }
}


# ---------------------------
# EKS Node Group
# ---------------------------
resource "aws_eks_node_group" "worker-nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.project_name}-nodegroup"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnets
  instance_types  = ["c7i-flex.large"]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  remote_access {
    ec2_ssh_key               = var.key_name
    source_security_group_ids = [aws_security_group.eks_nodes.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy
  ]
}

