terraform {
  source = "github.com/insight-icon/terraform-icon-monitor-aws-rds.git?ref=${local.vars.versions.aws.rds}"
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

//  instance_class = local.vars.instance_class

  subnet_ids = dependency.network.outputs.public_subnets
  security_group = dependency.network.outputs.rds_security_group_id
}
