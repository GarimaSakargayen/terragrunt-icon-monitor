terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  secrets = yamldecode(file(find_in_parent_folders("secrets.yaml")))
}

inputs = {
  public_key = file(local.secrets.public_key_path)
  private_key_path = local.secrets.private_key_path

  root_domain_name = local.secrets.root_domain_name
  hostname = "statusfy"
}
