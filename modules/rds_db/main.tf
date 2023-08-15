#####################################
# Terraform Version and Providers
#####################################
terraform {
  required_version = "~> 1.5.3"
  required_providers {
    aws = {
      version = "~> 5.10.0"
    }
  }
}
provider "aws" {
  region = var.region
}

#####################################
# Database and Subnet Group
#####################################

resource "aws_db_subnet_group" "default" {
  name       = "${var.name_prefix}_db_subnet_group"
  subnet_ids = var.db_subnet_ids
}

resource "aws_db_instance" "default" {
  identifier                 = "${var.name_prefix}-db"
  db_subnet_group_name       = aws_db_subnet_group.default.name
  allocated_storage          = var.storage
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.minor_version_upgrade
  backup_retention_period    = var.backup_retention
  blue_green_update {
    enabled = var.blue_green_update_enabled
  }
  delete_automated_backups        = var.del_auto_backups
  deletion_protection             = var.deletion_protection
  enabled_cloudwatch_logs_exports = var.cw_logs_exports
  engine                          = var.engine
  engine_version                  = var.engine_version
  multi_az                        = var.multi_az
  instance_class                  = var.instance_class
  username                        = var.username
  password                        = var.password
  port                            = var.open_port
  publicly_accessible             = var.publicly_accessible
  skip_final_snapshot             = var.skip_final_snapshot
  storage_encrypted               = var.encrypted
  final_snapshot_identifier       = var.final_snapshot_name
  max_allocated_storage           = var.max_storage
  vpc_security_group_ids = [
    aws_security_group.db_access.id
  ]
}

#####################################
# Security Groups
#####################################
resource "aws_security_group" "db_access" {
  name        = "${var.name_prefix}_db_access_sg"
  description = var.db_access_sg_description
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.open_port
    to_port         = var.open_port
    protocol        = var.db_protocol
    security_groups = [var.db_access_source_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
