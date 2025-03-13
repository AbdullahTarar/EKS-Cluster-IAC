module "s3" {
  source      = "./aws-modules/S3"
  bucket_name = var.bucket_name
}

module "vpc" {
  source                 = "./aws-modules/vpc"
  availability_zones     = var.availability_zones
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  project_name           = var.project_name
  ssh-port = var.ssh-port
  http-port = var.http-port
  https-port = var.https-port
}

# module "ec2_instances" {
#   source         = "./aws-modules/ec2-instances"
#   project_name   = var.project_name
#   instance_count = var.instance_count
#   instance_type  = var.instance_type
#   key_name       = var.key_name
#   vpc_id         =module.vpc.vpc_id
#   private_subnet_ids = module.vpc.private_subnet_ids
#   vpc_cidr = var.vpc_cidr
#   all_cidr = var.all_cidr
#   ssh-port = var.ssh-port
#   http-port = var.http-port
#   https-port = var.https-port
  
#   # target_group_arn = aws_lb_target_group.target_group.arn
#   # target_port    = 80
# }

module "eks" {
  source               = "./aws-modules/eks"
  cluster_name         = var.cluster_name
  cluster_version      = var.cluster_version
  project_name         = var.project_name
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.private_subnet_ids
 
 
}

module "lb" {
  source               = "./aws-modules/load-balancer"
  project_name         = var.project_name
  vpc_id               = module.vpc.vpc_id
  public_subnets_ids   = module.vpc.public_subnets_ids
  lb_security_group_id = module.vpc.sg_for_elb_eks_id
  
  # instance_ids         = module.ec2_instances.instance_ids
}

