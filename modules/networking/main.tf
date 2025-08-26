# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}
# public subnet
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = element(var.az, count.index)
  tags = {
    Name = "banking-public-subnet-${count.index + 1}"
  }
}
#private subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = element(var.az, count.index)
  tags = {
    Name = "banking-private-subnet-${count.index + 1}"
  }
}
#Inernet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "banking-IGW"
  }
}
#Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "banking_public-rt"
  }
}
#Public Route Table and Public subnets association
resource "aws_route_table_association" "public_rt_association" {
  count          = length(aws_subnet.public_subnet)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}
#elastic ip for NAT Gateway
resource "aws_eip" "nat_eip" {
  count  = length(aws_subnet.private_subnet)
  domain = "vpc"
  tags = {
    Name = "nat_eip-${count.index + 1}"
  }
}
# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.private_subnet_cidr)
  subnet_id     = aws_subnet.public_subnet[count.index].id
  allocation_id = aws_eip.nat_eip[count.index].id
  tags = {
    Name = "nat-gateway-${count.index + 1}"
  }
}
# Private Route Table 
resource "aws_route_table" "private_rt" {
  count  = length(aws_subnet.private_subnet)
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-rt-${count.index + 1}"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }
}
# private Route Table association
resource "aws_route_table_association" "private_rt_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}