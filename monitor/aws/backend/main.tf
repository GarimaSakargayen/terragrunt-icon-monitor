module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"

  name = var.name

  tags = {
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
}

module "db" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds?ref=master"

  identifier = "demodb-postgres"

  engine            = "postgres"
  engine_version    = "9.6.9"
  family = "postgres9.6"
  major_engine_version = "9.6"

  instance_class    = "db.t3.small"

  allocated_storage = 5
  storage_encrypted = false

  name = "demodb"

  username = var.username
  password = var.password

  port     = "5432"

  vpc_security_group_ids = [var.security_group]
  subnet_ids = var.subnet_ids

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  final_snapshot_identifier = "cachet"
  deletion_protection = false

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = module.label.tags
}

module "postgres" {
  source = "./postgres"

  host = module.db.this_db_instance_address
  password = var.password
  username = var.username
}
