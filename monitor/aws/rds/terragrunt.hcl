terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-rds.git?ref=${local.vars.versions.aws.rds}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  version = yamldecode(file(find_in_parent_folders("versions.yaml")))[local.vars.environment].aws.rds

  network = find_in_parent_folders("network")
}

dependencies {
  paths = [local.network]
}

dependency "network" {
  config_path = local.network
}

inputs = {
  username = local.vars.secrets.db_username
  password = local.vars.secrets.db_password

  instance_class = local.vars.env_vars.db_instance_class

  name = "monitor"
  identifier = local.vars.environment

  subnet_ids = dependency.network.outputs.public_subnets
  security_group = dependency.network.outputs.rds_security_group_id

  engine               = "postgres"
  engine_version       = "9.6.9"
  family               = "postgres9.6"
  major_engine_version = "9.6"

  allocated_storage = 5
  storage_encrypted = false

  port = "5432"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0

  final_snapshot_identifier = "cachet-${local.vars.environment}"
  deletion_protection       = false

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
}
