resource "aws_db_instance" "jwshin_rds" {
    allocated_storage = 20
    storage_type = "gp2"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t2.micro"
    name = "test"
    identifier = "test"
    username = "admin"
    password = "It12345!"
    parameter_group_name = "default.mysql8.0"
    availability_zone = "${var.region}a"
    db_subnet_group_name = aws_db_subnet_group.jwshin_dbsb.id
        vpc_security_group_ids = [aws_security_group.jwshin_sg.id]
    skip_final_snapshot = true
    tags = {
      "Name" = "jwshin-rds"
    } 
}

resource "aws_db_subnet_group" "jwshin_dbsb" {
    name = "${var.name}-dbsb-group"
    subnet_ids = [aws_subnet.jwshin_pridb[0].id,aws_subnet.jwshin_pridb[1].id]
    tags = {
      "Name" = "${var.name}-dbsb-gp"
    }
  
}