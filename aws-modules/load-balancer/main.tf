resource "aws_lb" "eks_lb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_security_group_id]
  subnets            = [for id in var.public_subnets_ids : id]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.eks_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_target_group.arn
  }
}

# resource "aws_lb_listener" "https_listener" {
#   load_balancer_arn = aws_lb.application_lb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.ssl_certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.main_target_group.arn
#   }
# }

resource "aws_lb_target_group" "eks_target_group" {
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  
#   health_check {
#     path                = "/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     matcher             = "200"
#   }
}
resource "aws_lb_target_group_attachment" "instance_attachments" {
  count             = var.instance_count 
  target_group_arn  = aws_lb_target_group.eks_target_group.arn
  target_id         = var.instance_ids[count.index]
  port              = 80
}
