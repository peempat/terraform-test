resource "aws_vpc" "testVPC" {
  cidr_block           = var.network_address_space
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-VPC" }
  )
}

resource "aws_subnet" "Public1" {
  vpc_id                  = aws_vpc.testVPC.id
  cidr_block              = var.subnet1_address_space
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-Public1" }
  )
}

resource "aws_subnet" "Public2" {
  vpc_id                  = aws_vpc.testVPC.id
  cidr_block              = var.subnet2_address_space
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-Public2" }
  )
}

resource "aws_internet_gateway" "testIgw" {
  vpc_id = aws_vpc.testVPC.id

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-IGW" }
  )
}

resource "aws_route_table" "publicRoute" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIgw.id
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-publicRoute" }
  )
}
