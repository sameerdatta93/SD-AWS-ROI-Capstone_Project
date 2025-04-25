resource "aws_lb" "app_alb" {
  name               = "appALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets
  tags = {
	Environment= "dev"
  }
}

#resource "aws_lb_target_group" "app_tg1" {
#  name     = "app-tg"
#  port     = 3001
#  protocol = "HTTP"
#  vpc_id   = var.vpc_id
#}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"
}
}

#resource "aws_lb_listener" "frontend" {
#  load_balancer_arn = aws_lb.app_alb.arn
#  port              = 3001
# protocol          = "HTTP"

#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.app_tg.arn
#  }
#}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
