resource "aws_alb" "alb" {
  name            = local.alb_name
  subnets         = [local.subnet_1, local.subnet_2]
  security_groups = [local.sg_http]
  internal        = false
  idle_timeout    = 61
  enable_http2    = false

  tags = {
    Name = local.alb_name
  }

  access_logs {
    bucket = aws_s3_bucket.alb_log.bucket
    prefix = "ELB-logs"
  }


}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = [aws_alb_target_group.alb_target_group]
  listener_arn = aws_alb_listener.alb_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.id
  }
  condition {
    field  = "path-pattern"
    values = ["/test"]
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name     = local.alb_name
  port     = "80"
  protocol = "HTTP"
  vpc_id   = local.vpc
  tags = {
    name = local.alb_name
  }
}

resource "aws_alb_target_group_attachment" "server_1" {
  target_group_arn = aws_alb_target_group.alb_target_group.arn
  target_id        = aws_instance.server_1.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "server_2" {
  target_group_arn = aws_alb_target_group.alb_target_group.arn
  target_id        = aws_instance.server_2.id
  port             = 80
}