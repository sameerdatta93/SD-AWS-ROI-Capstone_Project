resource "aws_db_subnet_group" "subnets"{
 name = "db-subnet"
 subnet_ids = [var.subnet_ids[0], var.subnet_ids[1]]
}
resource "aws_db_instance" "rds" {
  identifier         = "feedback-records"
  engine             = "mysql"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  username           = "admin"
  password           = "pasword1234"
  vpc_security_group_ids = [var.sg_id]
  db_subnet_group_name   = aws_db_subnet_group.subnets.name
  skip_final_snapshot    = true
  tags = {
    Name = "feedback_table"
  }
}

