

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones"{
    description ="list of availability zones"
    type        = list(string)
}

variable "project_name" {
  description = "Name of the project"
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

variable "cluster_name" {
    description = "Name of the eks cluster"
    type = string
}



