variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets_ids" {
  description = "List of public subnets"
  type        = list(string)
}

variable "lb_security_group_id" {
  description = "Security Group ID for Load Balancer"
  type        = string
}

# variable "ssl_certificate_arn" {
#   description = "ARN for the SSL certificate"
#   type        = string
# }

variable "instance_ids" {
  description = "List of instance IDs to register in the target group"
  type        = list(string)
}
variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}