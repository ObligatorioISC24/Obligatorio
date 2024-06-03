resource "aws_db_instance" "obligatorio-rds" {

  allocated_storage = 20

  storage_type = "gp2"

  engine = "mysql"

  instance_class = "db.t3.micro"

  identifier = var.DB_DATABASE

  username = var.DB_USER

  password = var.DB_PASSWORD

  db_name = var.DB_DATABASE

  vpc_security_group_ids = [aws_security_group.obligatorio-sg-RDS.id]

  db_subnet_group_name = aws_db_subnet_group.network-group-obligatorio.id

  skip_final_snapshot = true
#backup de la base 
  backup_retention_period = var.retention_period
}
