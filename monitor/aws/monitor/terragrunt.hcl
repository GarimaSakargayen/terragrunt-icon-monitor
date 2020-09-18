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
  env_file = "env-files/.env.${local.vars.environment}"

  # Network
  security_group_id = dependency.network.outputs.cachet_security_group_id
  subnet_id = dependency.network.outputs.public_subnets[0]

  db_host = dependency.backend.outputs.this_db_instance_address
}
