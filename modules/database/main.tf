resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "database" {
  engine                 = "postgres"
  engine_version         = "14.4"
  instance_class         = "db.t3.medium"
  allocated_storage      = 20
  identifier             = "${var.project}-db-instance"
  name                   = "terraform"
  username               = "phuongnv"
  password               = random_password.password.result
  db_subnet_group_name   = var.vpc.database_subnet_group
  vpc_security_group_ids = [var.sg.db]
  skip_final_snapshot    = true
}
