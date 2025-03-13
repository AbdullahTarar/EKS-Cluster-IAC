# Create EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [for id in var.public_subnet_ids : id]
  }

  version = var.cluster_version

}

# EKS Cluster IAM Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
  ])

  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = each.value
}



# # Generate RSA Private Key
# resource "tls_private_key" "rsa_tr_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# # Create Key Pair
# resource "aws_key_pair" "wp_key" {
#   key_name   = var.key_name
#   public_key = tls_private_key.rsa_tr_key.public_key_openssh
# }

# # Save Private Key to a Local File
# resource "local_file" "rsa_tr_key" {
#   content  = tls_private_key.rsa_tr_key.private_key_pem
#   filename = "${path.module}/rsa_tr_key.pem"
# }


resource "aws_eks_node_group" "managed_nodes" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-managed-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [for id in var.public_subnet_ids : id]
  



  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  ami_type             = "AL2_x86_64" # Amazon Linux 2 AMI
  instance_types       = ["t2.micro"] # Free Tier eligible instance
  capacity_type        = "ON_DEMAND"  # Avoid using Spot for now

 
}

# IAM Role for the Managed Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "${var.project_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  ])

  policy_arn = each.value
  role       = aws_iam_role.eks_node_role.name
}
