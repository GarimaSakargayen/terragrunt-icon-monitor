terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  secrets = yamldecode(file(find_in_parent_folders("secrets.yaml")))
  network = find_in_parent_folders("network")
  backend = find_in_parent_folders("backend")
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
  env_file = local.secrets.cachet.env_file

  # DB
  db_username = local.secrets.db.username
  db_password = local.secrets.db.password
  db_host = dependency.backend.outputs.this_db_instance_address

  # Keys
  public_key = file(local.secrets.public_key_path)
  private_key_path = local.secrets.private_key_path

  # DNS
  root_domain_name = local.secrets.root_domain_name
  hostname = local.secrets.cachet.hostname

  # Network
  security_group_id = dependency.network.outputs.cachet_security_group_id
  subnet_id = dependency.network.outputs.public_subnets[0]
}
