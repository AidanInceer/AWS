resource "aws_db_instance" "db_1" {
  identifier             = "database-1"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14"
  username               = "edu"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  parameter_group_name   = aws_db_parameter_group.sample.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}


resource "aws_db_parameter_group" "sample" {
  name   = "sample"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "subnet_group"
  subnet_ids = [
    var.subnet_a_id,
    var.subnet_b_id
  ]
}
