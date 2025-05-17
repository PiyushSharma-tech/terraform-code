resource "aws_vpc" "documentdb_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "documentdb_subnet_a" {
  vpc_id            = aws_vpc.documentdb_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a" # First AZ
}

resource "aws_subnet" "documentdb_subnet_b" {
  vpc_id            = aws_vpc.documentdb_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b" # Second AZ
}

resource "aws_security_group" "documentdb_sg" {
  vpc_id = aws_vpc.documentdb_vpc.id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change to your desired CIDR block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "documentdb_subnet_group" {
  name       = "documentdb-subnet-group"
  subnet_ids = [aws_subnet.documentdb_subnet_a.id, aws_subnet.documentdb_subnet_b.id] # Include both subnets

  tags = {
    Name = "DocumentDB Subnet Group"
  }
}

resource "aws_docdb_cluster" "documentdb_cluster" {
  cluster_identifier          = "my-documentdb-cluster"
  master_username             = "myuser"
  master_password             = "mypassword" # Use a secure method to manage passwords
  skip_final_snapshot         = true
  engine                      = "docdb"
  engine_version              = "4.0.0" # Change to your desired version
  vpc_security_group_ids      = [aws_security_group.documentdb_sg.id]
  db_subnet_group_name        = aws_db_subnet_group.documentdb_subnet_group.name
}

resource "aws_docdb_cluster_instance" "documentdb_instance" {
  count               = 2 # Number of instances
  cluster_identifier  = aws_docdb_cluster.documentdb_cluster.id
  instance_class      = "db.r5.large" # Change to your desired instance class
  engine              = "docdb"
}



/*
resource "aws_docdb_cluster" "docdb" {
cluster_identifier = "my-docdb-cluster"
engine = "docdb"
master_username = "foo"
master_password = "mustbeeightchars"
backup_retention_period = 5
preferred_backup_window = "07:00-09:00"
skip_final_snapshot = true
} */