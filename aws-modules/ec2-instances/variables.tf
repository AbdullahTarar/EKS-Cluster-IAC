variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
variable "key_name" {
  description = "Key name for the EC2 instances"
  type        = string
}

variable "http-port" {
  description = "port for http access"
  type        = string
}

variable "https-port" {
  description = "port for https access"
  type        = string
}
variable "ssh-port" {
  description = "port for ssh access"
  type        = string
}

variable "all_cidr" {
  description = "Allow access from all IPs"
  type = string
}
variable "project_name" {
  description = "Project name for tagging and identification"
  type        = string
}

variable "vpc_id" {
    description = "Id of the vpc"
    type = string
}


variable "vpc_cidr" {
  description = "Allow access from vpc IPs"
  type = string
}

variable "private_subnet_ids" {
    description = "Ids of private subnets"
    type=list(string)
  
}