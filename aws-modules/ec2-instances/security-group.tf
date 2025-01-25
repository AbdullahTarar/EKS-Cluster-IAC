# Security Group for EC2 Instances
resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.project_name}-ec2-sg"
  vpc_id      = var.vpc_id

  # Allow SSH
  ingress {
    from_port   = var.ssh-port
    to_port     = var.ssh-port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow HTTP
  ingress {
    from_port   = var.http-port
    to_port     = var.http-port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    # cidr_blocks = [sg_for_elb_eks.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}



resource "aws_security_group" "sg_for_elb_eks" {
  name   = "demo-eks-project-lb-sg"
  vpc_id = var.vpc_id

  ingress {
    description      = "Allow http request from anywhere"
    protocol         = "tcp"
    from_port        = var.http-port
    to_port          = var.http-port
    cidr_blocks      = [var.all_cidr]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow https request from anywhere"
    protocol         = "tcp"
    from_port        = var.https-port
    to_port          = var.https-port
    cidr_blocks      = [var.all_cidr]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }

  tags = {
    Name = "eks-load-balancer-sg"
  }
}