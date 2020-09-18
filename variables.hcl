locals {
  namespace = "icon-monitor"
  environment = "dev"
  region = "us-east-1"

  cluster_name = "${local.namespace}-${local.environment}"

  secrets = yamldecode(file("${get_parent_terragrunt_dir()}/secrets.yaml"))[local.environment]
  versions = yamldecode(file("${get_parent_terragrunt_dir()}/versions.yaml"))[local.environment]

  env_vars = lookup(local.env_vars_map, local.environment)
  env_vars_map = {
    prod = {
      root_domain_name = "status-page.net"
      hostname = "icon"

      db_instance_class = "db.t3.medium"
    }

    dev = {
      root_domain_name = "blockstatus.net"
      hostname = "icon"

      db_instance_class = "db.t3.medium"
    }
  }

  region_vars = lookup(local.region_vars_map, local.region)
  region_vars_map = {
    us-east-1 = {
      num_azs = 3
    }
  }

  ###################
  # Label Boilerplate
  ###################
  label_map = {
    namespace = local.namespace
    environment = local.environment
    region = local.region
  }

  remote_state_path_label_order = ["namespace", "environment", "region"]
  remote_state_path = join("/", [ for i in local.remote_state_path_label_order : lookup(local.label_map, i)])

  id_label_order = ["namespace", "environment"]
  id = join("", [ for i in local.id_label_order : title(lookup(local.label_map, i))])

  name_label_order = ["namespace", "environment"]
  name = join("-", [ for i in local.name_label_order : title(lookup(local.label_map, i))])

  tags = { for t in local.remote_state_path_label_order : t => lookup(local.label_map, t) }
}


