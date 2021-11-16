resource "aws_security_group" "jwshin_sg" {
  name        = "Allow Basic"
  description = "Allow HTTP,SSH,SQL,ICMP"
  vpc_id      = aws_vpc.jwshin_vpc.id

  ingress = [
    {
      description      = "Allow HTTP"
      from_port        = var.port_http
      to_port          = var.port_http
      protocol         = "tcp"
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_ipv6]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "Allow SSH"
      from_port        = var.port_ssh
      to_port          = var.port_ssh
      protocol         = "tcp"
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_ipv6]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "Allow SQL"
      from_port        = var.port_sql
      to_port          = var.port_sql
      protocol         = "tcp"
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_ipv6]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "Allow ICMP"
      from_port        = 0
      to_port          = 0
      protocol         = "icmp"
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_ipv6]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = "ALL"
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_ipv6]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

}

resource "aws_instance" "jwshin_weba" {
  ami               = "ami-04e8dfc09b22389ad"
  instance_type     = "t2.micro"
  key_name          = ""
  availability_zone = "ap-northeast-2a"
  private_ip        = "10.0.0.11"
  subnet_id         = aws_subnet.jwshin_pub[0].id
  vpc_security_group_ids = [aws_security_group.jwshin_sg.id]
  user_data         = file("../01_test/install.sh")
}

resource "aws_eip" "jwshin_weba_ip" {
  vpc                       = true
  instance                  = aws_instance.jwshin_weba.id
  associate_with_private_ip = "10.0.0.11"
  depends_on = [
    aws_internet_gateway.jwshin_ig
  ]

}

output "public_ip" {
  value = aws_instance.jwshin_weba.public_ip
}