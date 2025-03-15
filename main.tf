
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

  module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "19.20.0"

    cluster_name                    = var.cluster_name
    cluster_version                 = var.cluster_version
    cluster_endpoint_private_access = true
    cluster_endpoint_public_access  = true
    cluster_additional_security_group_ids = [module.vpc.ec2_sg_id]

    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnet_ids

    eks_managed_node_group_defaults = {
      ami_type               = "AL2_x86_64"
      disk_size              = 20
      instance_types         = ["t2.micro"]
      vpc_security_group_ids = [module.vpc.ec2_sg_id]
    }

    eks_managed_node_groups = {
      green = {
        min_size     = 1
        max_size     = 2
        desired_size = 1

        instance_types = ["t2.micro"]
        capacity_type  = "SPOT"

    }

  }
  }

module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.cluster_name}-eks-lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider
    
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "kubernetes_service_account" "service-account" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
        "app.kubernetes.io/name"= "aws-load-balancer-controller"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "lb" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version = "1.4.1"
  depends_on = [
    kubernetes_service_account.service-account
  ]

  set {
    name  = "region"
    value = "us-east-1"
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}


