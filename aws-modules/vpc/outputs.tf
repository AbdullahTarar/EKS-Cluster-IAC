output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.eks_vpc.id
}
output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}
output "public_subnets_ids" {
  description = "The public subnets"
  value       = aws_subnet.public_subnets[*].id
}