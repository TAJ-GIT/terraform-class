# vpc creation
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "name" = "RDS-VPC"
    }
}
# subnets creation
resource "aws_subnet" "subnet-1"{
    vpc_id = aws_vpc.name.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.0.0/24"
}
resource "aws_subnet" "subnet-2"{
    vpc_id = aws_vpc.name.id
    availability_zone = "us-east-1b"
    cidr_block = "10.0.1.0/24"
}
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "dbgroup"  # 👈 explicit name
  subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]

  tags = {
    Name = "DB Subnet Group"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL access"
  vpc_id      = aws_vpc.name.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}
#RDS-creation
resource "aws_db_instance" "default" {
  identifier             = "mydb-instance"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "Admin12345!"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "MyRDS"
  }
}


