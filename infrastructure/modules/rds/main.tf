# DB Subnet Group (RDS must be in private subnets)
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.project_name}-db-subnet"
  }
}

# RDS Security Group
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "RDS security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

# Allow MySQL access from EKS worker nodes
resource "aws_security_group_rule" "allow_eks_to_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = var.eks_sg_id
}

# RDS Instance
resource "aws_db_instance" "mysql" {
  identifier              = "${var.project_name}-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  deletion_protection     = false

  tags = {
    Name = "${var.project_name}-mysql"
  }
}

