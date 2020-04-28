
locals {
  namespace = "icon-monitor"
  environment = "dev"
  region = "us-east-1"

  cluster_name = "${local.namespace}-${local.environment}"

  secrets = yamldecode(file("${get_parent_terragrunt_dir()}/secrets.yaml"))[local.environment]
  versions = yamldecode(file("versions.yaml"))[local.environment]

  env_vars = lookup(local.env_vars_map, local.environment)
  env_vars_map = {
    prod = {
      root_domain_name = "status-page.net"
      hostname = "icon"

      instance_class = "db.t3.medium"
    }

    dev = {
      root_domain_name = "blockstatus.net"
      hostname = "icon"

      instance_class = "db.t3.small"
    }
  }

  region_vars = lookup(local.region_vars_map, local.region)
  region_vars_map = {
    us-east-1 = {
      num_azs = 3
    }
  }
}


