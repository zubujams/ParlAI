provider "aws" {
  region  = "us-east-1" # Choose desired AWS region
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "default" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "parlai_sg" {
  name        = "parlai_sg"
  description = "Allow web and SSH traffic to ParlAI EC2 instance"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "parlai_ec2" {
  ami           = "ami-0000fakeami000" 
  instance_type = "t2.medium"             # Choose an instance type that suits the load
  subnet_id     = aws_subnet.default.id
  security_groups = [aws_security_group.parlai_sg.name]

  tags = {
    Name = "ParlAI_Instance"
  }
}

# For the project purpose, it wasn't specified to have a db. One can be added in the future if needed.
resource "aws_db_instance" "parlai_rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"  # Use the appropriate engine and version
  instance_class       = "db.t2.small"
  name                 = "parlaidb"
  username             = "parlaiuser"
  password             = "yourpassword" # Replace with a secure password or use a secret management service
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.default.name
  skip_final_snapshot  = true

  tags = {
    Name = "ParlAI_DB"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "parlai_db_subnet_group"
  subnet_ids = [aws_subnet.default.id]

  tags = {
    Name = "My DB subnet group"
  }
}


# You will want to make sure to run this file first before the CI-for-parlai.yml