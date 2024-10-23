resource "aws_lb" "elb-webLB" {
  name               = "elb-WebLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh_web.id]
  subnets            = [aws_subnet.Public1.id, aws_subnet.Public2.id]

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-elb-webLB" }
  )
}

resource "aws_lb_target_group" "target_group" {
  name     = "elb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.testVPC.id

  health_check {
    path     = "/"
    protocol = "HTTP"
    interval = 30
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-elb-tg" }
  )
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.elb-webLB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "tg-attachment-server1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.Server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg-attachment-server2" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.Server2.id
  port             = 80
}
