resource "aws_eip" "jwshin_eip_ng" {
  vpc = true
}

resource "aws_nat_gateway" "jwshin_ng" {
  allocation_id = aws_eip.jwshin_eip_ng.id
  subnet_id     = aws_subnet.jwshin_pub[0].id
  tags = {
    "Name" = "${var.name}-ng"
  }
  depends_on = [
    aws_internet_gateway.jwshin_ig
  ]
}

resource "aws_route_table" "jwshin_ngrt" {
  vpc_id = aws_vpc.jwshin_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.jwshin_ng.id
  }
  tags = {
    "Name" = "${var.name}-ngrt"
  }
}

resource "aws_route_table_association" "jwshin_ngass_a" {
  subnet_id      = aws_subnet.jwshin_pri[0].id
  route_table_id = aws_route_table.jwshin_ngrt.id
}

resource "aws_route_table_association" "jwshin_ngass_c" {
  subnet_id      = aws_subnet.jwshin_pri[1].id
  route_table_id = aws_route_table.jwshin_ngrt.id
}
