resource "aws_security_group" "allow_ssh_web" {
  name        = "npaWk11_demo"
  description = "Allow ssh and web access"
  vpc_id      = aws_vpc.testVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-SG" }
  )
}

resource "aws_instance" "Server1" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]
  subnet_id              = aws_subnet.Public1.id

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-Server1" }
  )
}

resource "aws_instance" "Server2" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]
  subnet_id              = aws_subnet.Public2.id

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-Server2" }
  )
}
