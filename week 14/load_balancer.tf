resource "aws_lb" "elb-webLB" {
  name               = "${local.resource_prefix}-elb-webLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.AllowSSHandWeb.id]
  subnets            = tolist([for subnet in aws_subnet.PublicSubnet : subnet.id])
  
  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-elb-webLB" }
  )
}

# target group for the load balancer
resource "aws_lb_target_group" "target_group" {
  name        = "elb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.testVPC.id

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

#Create a listener for the Load Balancer
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.elb-webLB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

#Register EC2 instances to the Target Group
resource "aws_lb_target_group_attachment" "tg-attachment" {
  count            = var.subnet_count
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.Server[count.index].id
  port             = 80
}


