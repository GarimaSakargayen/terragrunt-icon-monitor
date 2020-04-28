terraform {
  source = "github.com/insight-icon/terraform-icon-monitor-aws-cachet.git?ref=${local.vars.versions.aws.cachet}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals

  network = find_in_parent_folders("network")
  backend = find_in_parent_folders("rds")
}

dependencies {
  paths = [local.network, local.backend]
}

dependency "network" {
  config_path = local.network
}

dependency "backend" {
  config_path = local.backend
}

inputs = {
//  env_file = local.secrets.cachet.env_file
//
//  # DB
//  db_username = local.vars.secrets.db.username
//  db_password = local.vars.secrets.db.password
//  db_host = dependency.backend.outputs.this_db_instance_address
//
//  # Keys
//  public_key = file(local.vars.secrets.public_key_path)
//  private_key_path = local.vars.secrets.private_key_path
//
//  # DNS
//  root_domain_name = local.vars.root_domain_name
//  hostname = local.vars.cachet.hostname

  # Network
  security_group_id = dependency.network.outputs.cachet_security_group_id
  subnet_id = dependency.network.outputs.public_subnets[0]
}
