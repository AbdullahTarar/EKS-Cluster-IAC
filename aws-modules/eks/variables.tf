variable "project_name" {
  description = "Project name for tagging and identification"
  type        = string
}

variable "cluster_name" {
    description = "Name of the eks cluster"
    type = string
}

variable "cluster_version" {
    description = "Version of the eks cluster"
    type = string
}
variable "public_subnet_ids" {
    description = "Ids of private subnets"
    type=list(string)
  
}

variable "vpc_id" {
    description = "Id of the vpc"
    type = string
}


