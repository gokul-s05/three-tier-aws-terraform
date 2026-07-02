# DB Subnet Group - tells RDS which subnets it's allowed to use
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

# DB Security Group - only accepts traffic from the app tier
resource "aws_security_group" "db" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "Allow Postgres traffic only from app tier"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Postgres from app tier only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-db-sg"
  }
}

# RDS Instance - password managed natively by AWS in Secrets Manager
resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-${var.environment}-db"
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  allocated_storage     = var.db_allocated_storage
  storage_type           = "gp3"
  storage_encrypted      = true

  db_name  = var.db_name
  username = var.db_username

  # AWS generates and manages the master password in Secrets Manager.
  # No password ever appears in Terraform state, CLI output, or .tf files.
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  multi_az = var.db_multi_az

  backup_retention_period = 7
  backup_window            = "03:00-04:00"
  maintenance_window       = "mon:04:30-mon:05:30"

  # Learning project settings - makes teardown clean.
  # For real production, set deletion_protection = true and skip_final_snapshot = false.
  deletion_protection = false
  skip_final_snapshot  = true

  tags = {
    Name = "${var.project_name}-${var.environment}-db"
  }
}
