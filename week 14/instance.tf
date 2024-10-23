resource "aws_security_group" "AllowSSHandWeb" {
  name        = "AllowSSHandWeb"
  description = "Allow incoming SSH and HTTP traffic to EC2 Instance"
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

# no more Server1 Server2 
resource "aws_instance" "Server" {
  count                  = var.subnet_count
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.AllowSSHandWeb.id]
  subnet_id              = aws_subnet.PublicSubnet[count.index].id

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-Server${count.index + 1}" }
  )
}


