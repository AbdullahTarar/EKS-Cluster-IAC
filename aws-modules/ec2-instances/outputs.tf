output "sg_for_elb_eks_id" {
  description = "security group id for lb"
  value       = aws_security_group.sg_for_elb_eks.id
}
output "instance_ids" {
  description = "The IDs of the private subnets"
  value       = aws_instance.ec2_instances.*.id
}