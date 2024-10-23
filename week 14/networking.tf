resource "aws_vpc" "testVPC" {
  cidr_block           = var.network_address_space
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-VPC" }
  )
}

resource "aws_subnet" "PublicSubnet" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.testVPC.id
  cidr_block              = cidrsubnet(var.network_address_space, 8, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-Subnet${count.index + 1}" }
  )
}

resource "aws_internet_gateway" "testIgw" {
  vpc_id = aws_vpc.testVPC.id

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-IGW" }
  )
}


resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIgw.id
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_prefix}-PublicRouteTable" }
  )
}

#Associate Route Table with Subnets
resource "aws_route_table_association" "PublicRouteTableAssociation" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.PublicSubnet[count.index].id
  route_table_id = aws_route_table.PublicRouteTable.id
}
