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

output "sg_for_elb_eks_id" {
  description = "security group id for lb"
  value       = aws_security_group.sg_for_elb_eks.id
}
output "ec2_sg_id" {
  description = "The IDs of the private subnets"
  value       = aws_security_group.ec2_sg.id
}