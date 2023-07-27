provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_db_instance" "myRDS" {
  name                = "myDB"
  identifier          = "my-first-rds"
  instance_class      = "db.t2.micro"
  engine              = "mariadb"
  engine_version      = "10.2.21"
  username            = "admin"
  password            = "adminPassword"
  port                = 3306
  allocated_storage   = 10
  skip_final_snapshot = true
}
