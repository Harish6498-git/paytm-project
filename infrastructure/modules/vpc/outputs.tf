output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = [aws_subnet.public.id]
}

output "private_subnets" {
  value = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

