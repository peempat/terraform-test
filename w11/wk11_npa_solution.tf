##################################################################################
# VARIABLES
##################################################################################
variable "aws_access_key" {
  default = ""
}
variable "aws_secret_key" {
  default = ""
}
variable "aws_session_token" {
  default = ""
}
variable "key_name" {
  default = "vockey"
}
variable "default_region" {
  default = "us-east-1"
}


################################
#LOCAL
################################

locals {
  common_tags = {
    Name = "itkmitl-npa24"
  }
}


#################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
  region     = var.default_region
}

##################################################################################
# DATA
##################################################################################
## this 
data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


##################################################################################
# RESOURCES
##################################################################################
## this
resource "aws_vpc" "testVPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "testVPC"
  }
}

resource "aws_subnet" "Public1" {
  vpc_id                  = aws_vpc.testVPC.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public1"
  }
}
## 

resource "aws_internet_gateway" "testIgw" {
  vpc_id = aws_vpc.testVPC.id

  tags = {
    Name = "testIgw"
  }
}

resource "aws_route_table" "publicRoute" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIgw.id
  }
  tags = {
    Name = "publicRoute"
  }
}

resource "aws_route_table_association" "rt-pubsub1" {
  subnet_id      = aws_subnet.Public1.id
  route_table_id = aws_route_table.publicRoute.id
}

## this 
resource "aws_security_group" "allow_ssh_web" {
  name        = "AllowSSHandWeb"
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
  tags = {
    Name = "AllowSSHandWeb"
  }
}

#EC2 Instance with 8 GB General Purpose SSD (EBS)
resource "aws_instance" "testServer" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]
  subnet_id              = aws_subnet.Public1.id

  #EBS block for general purpose SSD
    root_block_device {
    volume_size = 8           # 8 GB volume
    volume_type = "gp2"       # General Purpose SSD
    delete_on_termination = true
  }
  # tags = local.common_tags
  tags = {
    Name = "tfTest"    # Tag: Key = name, Value = tfTest
  }
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_ip" {
  value = aws_instance.testServer.public_ip
}
