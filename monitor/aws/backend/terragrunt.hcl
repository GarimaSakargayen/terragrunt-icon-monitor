terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  secrets = yamldecode(file(find_in_parent_folders("secrets.yaml")))
  network = find_in_parent_folders("network")
}

dependencies {
  paths = [local.network]
}

dependency "network" {
  config_path = local.network
}

inputs = {
  username = local.secrets.db.username
  password = local.secrets.db.password
  subnet_ids = dependency.network.outputs.public_subnets
  security_group = dependency.network.outputs.rds_security_group_id
}

