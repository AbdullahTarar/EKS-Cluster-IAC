# global/variables.tf
variable "state_bucket_name" {
  description = "Name of the S3 bucket for storing the Terraform state"
  type        = string
}

variable "state_key" {
  description = "Key path for the Terraform state file in the S3 bucket"
  type        = string
}

variable "state_region" {
  description = "AWS region where the S3 bucket is located"
  type        = string
  default     = "us-east-1"
}

#-------------------------------------------------------------------
#S3 variables
#-------------------------------------------------------------------

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

#-------------------------------------------------------------------
#vpc variables
#-------------------------------------------------------------------
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
# variable "vpc_id" {
#     description = "Id of the vpc"
#     type = string
# }


#-------------------------------------------------------------------
#EC2 variables
#-------------------------------------------------------------------

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
