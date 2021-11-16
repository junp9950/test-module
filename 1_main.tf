
provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "jwshin_vpc" {
  cidr_block = var.cidr_main
  tags = {
    "Name" = "${var.name}-vpc"
  }
}

# 가용영역의 Public Subnet
resource "aws_subnet" "jwshin_pub" {
  count             = length(var.cidr_public)
  vpc_id            = aws_vpc.jwshin_vpc.id
  cidr_block        = var.cidr_public[count.index]
  availability_zone = "${var.region}${var.ava[count.index]}"
  tags = {
    "Name" = "${var.name}-pub${var.ava[count.index]}"
  }
}

# 가용영역의 Private Subnet
resource "aws_subnet" "jwshin_pri" {
    count             = length(var.cidr_private)
  vpc_id            = aws_vpc.jwshin_vpc.id
  cidr_block        = var.cidr_private[count.index]
  availability_zone = "${var.region}${var.ava[count.index]}"
  tags = {
    "Name" = "${var.name}-pri${var.ava[count.index]}"
  }
}

# 가용영역의 Private DB Subnet
resource "aws_subnet" "jwshin_pridb" {
    count             = length(var.cidr_privatedb)
  vpc_id            = aws_vpc.jwshin_vpc.id
  cidr_block        = var.cidr_privatedb[count.index]
  availability_zone = "${var.region}${var.ava[count.index]}"
  tags = {
    "Name" = "${var.name}-pridb${var.ava[count.index]}"
  }
}

#Internet gateway
resource "aws_internet_gateway" "jwshin_ig" {
  vpc_id = aws_vpc.jwshin_vpc.id

  tags = {
    "Name" = "${var.name}-ig"
  }
}
#Route table
resource "aws_route_table" "jwshin_rf" {
  vpc_id = aws_vpc.jwshin_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jwshin_ig.id
  }
  tags = {
    "Name" = "${var.name}-rt"
  }
}

#Route table association

resource "aws_route_table_association" "jwshin_rtass_a" {
  count          = length(var.cidr_public)
  subnet_id      = aws_subnet.jwshin_pub[count.index].id
  route_table_id = aws_route_table.jwshin_rf.id
}
