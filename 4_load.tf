resource "aws_lb" "jwshin_alb" {
  name               = "jwshin-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jwshin_sg.id]
  subnets            = [aws_subnet.jwshin_pub[0].id, aws_subnet.jwshin_pub[1].id]

  tags = {
    "Name" = "${var.name}-alb"
  }
}
output "alb_dns" {
    value = aws_lb.jwshin_alb.dns_name  
}

resource "aws_lb_target_group" "jwshin_albtg" {
  name     = "${var.name}-albtg"
  port     = 80
  protocol = var.protocol
  vpc_id   = aws_vpc.jwshin_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 5
    matcher             = "200"
    path                = "/health.html"
    port                = "traffic-port"
    protocol            = var.protocol
    timeout             = 2
    unhealthy_threshold = 2

  }

}

resource "aws_lb_listener" "jwshin_albli" {
  load_balancer_arn = aws_lb.jwshin_alb.arn
  port              = "${var.port_http}"
  protocol          = var.protocol



  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jwshin_albtg.arn
  }
}

resource "aws_lb_target_group_attachment" "jwshin_tgatt" {
  target_group_arn = aws_lb_target_group.jwshin_albtg.arn
  target_id        = aws_instance.jwshin_weba.id
  port             = var.port_http
}

