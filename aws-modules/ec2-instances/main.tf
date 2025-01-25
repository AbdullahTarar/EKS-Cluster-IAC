# Generate RSA Private Key
resource "tls_private_key" "rsa_tr_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create Key Pair
resource "aws_key_pair" "wp_key" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_tr_key.public_key_openssh
}

# Save Private Key to a Local File
resource "local_file" "rsa_tr_key" {
  content  = tls_private_key.rsa_tr_key.private_key_pem
  filename = "${path.module}/rsa_tr_key.pem"
}


# Data block to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"] # Amazon-owned AMIs
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*23.4-x86_64-gp2"]
  }
}

# Create EC2 instances
resource "aws_instance" "ec2_instances" {
  count                     = var.instance_count
  ami                       = data.aws_ami.amazon_linux.id
  instance_type             = var.instance_type
  subnet_id                 = var.private_subnet_ids[count.index]
  security_groups           = [aws_security_group.ec2_sg.id]
  key_name                  = var.key_name

  tags = {
    Name = "${var.project_name}-ec2-${count.index + 1}"
  }

#   # Adding instances to the target group
#   lifecycle {
#     create_before_destroy = true
#   }

#   depends_on = [aws_lb_target_group.target_group]
}

# Target Group Registration
# resource "aws_lb_target_group_attachment" "target_group_attachment" {
#   count            = var.instance_count
#   target_group_arn = var.target_group_arn
#   target_id        = aws_instance.ec2_instances[count.index].id
#   port             = var.target_port
# }
