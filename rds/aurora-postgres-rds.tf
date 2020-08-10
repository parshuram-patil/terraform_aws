locals {
  db_port_number = 5432
}


data "aws_kms_key" "rds_kms_key" { key_id = "alias/rds-kms-key" }

resource "random_id" "rds_password" { byte_length = 8 }

resource "aws_db_subnet_group" "aurora_postgres_db_subnet_group" {
  name        = "aurora-postgres-db-subnet-group"
  description = "Subnet Group for RDS instances"
  subnet_ids  = ["subnet-68d02c21", "subnet-da31c2bd", "subnet-95310ecd"]

  tags = {
    Name = "aurora_postgres_db_subnet_group"
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_postgres_db_parameter_group" {
  name        = "aurora-postgres-db-parameter-group"
  description = "Default parameter group for Aurora PostgreSQL Server 11.7 RDS instances"
  family      = "aurora-postgresql11"

  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "pending-reboot"
  }
  tags = {
    Name = "aurora_postgres_db_parameter_group"
  }
}

resource "aws_security_group" "aurora_postgres_db_sg" {
  name        = "aurora-postgres-db-sg"
  description = "Security group for SRC Validation Aget RDS instance"
  vpc_id      = "vpc-897b8dee"

  ingress {
    from_port   = local.db_port_number
    to_port     = local.db_port_number
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aurora_postgres_db_sg"
  }
}

resource "aws_rds_cluster" "aurora_postgres_aurora_postres_11_7_cluster" {
  cluster_identifier = "aurora-postgres-aurora-postres-11-7-cluster"
  //availability_zones              = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  database_name                   = "pspaurora"
  master_username                 = "master_username"
  master_password                 = "master_password"
  engine                          = "aurora-postgresql"
  engine_version                  = "11.7"
  backup_retention_period         = 5
  preferred_backup_window         = "07:00-09:00"
  skip_final_snapshot             = false
  final_snapshot_identifier       = "aurora-postgres-aurora-postres-11-7-snapshot"
  preferred_maintenance_window    = "sat:23:25-sat:23:56"
  port                            = local.db_port_number
  vpc_security_group_ids          = [aws_security_group.aurora_postgres_db_sg.id]
  storage_encrypted               = true
  db_subnet_group_name            = aws_db_subnet_group.aurora_postgres_db_subnet_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_postgres_db_parameter_group.id
  kms_key_id                      = data.aws_kms_key.rds_kms_key.arn
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_postgres_aurora_postres_11_7_cluster.id
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.aurora_postgres_aurora_postres_11_7_cluster.engine
  engine_version     = aws_rds_cluster.aurora_postgres_aurora_postres_11_7_cluster.engine_version
  //publicly_accessible = false
  copy_tags_to_snapshot = true
  //db_subnet_group_name            = aws_db_subnet_group.aurora_postgres_db_subnet_group.id
}

resource "aws_secretsmanager_secret" "aurora_postgres_db_secret" {
  description = "Secret to Store DB credentials of Aurora Postgres 11.7"
  name        = "aurora-postgres-db-secret"

  tags = {
    Name = "aurora_postgres_db_secret"
  }

}

resource "aws_secretsmanager_secret_version" "aurora_postgres_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.aurora_postgres_db_secret.id
  secret_string = <<EOF
{
  "master_username": "${aws_rds_cluster.aurora_postgres_aurora_postres_11_7_cluster.master_username}",
  "master_password": "${aws_rds_cluster.aurora_postgres_aurora_postres_11_7_cluster.master_password}",
  "engine": "${aws_rds_cluster.aurora_postgres_aurora_postres_11_7_cluster.engine}",
  "endpoint": "${aws_rds_cluster.aurora_postgres_aurora_postres_11_7_cluster.endpoint}",
  "reader_endpoint": "${aws_rds_cluster.aurora_postgres_aurora_postres_11_7_cluster.reader_endpoint}",
  "port": "${aws_rds_cluster.aurora_postgres_aurora_postres_11_7_cluster.port}",
  "database_name": "${aws_rds_cluster.aurora_postgres_aurora_postres_11_7_cluster.database_name}",
  "dbInstanceIdentifier": "${aws_rds_cluster.aurora_postgres_aurora_postres_11_7_cluster.cluster_identifier}"
}
EOF
}
