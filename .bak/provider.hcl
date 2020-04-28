locals {
  deployment_vars = read_terragrunt_config(("${get_parent_terragrunt_dir()}/deployment.hcl"))

  environment = local.deployment_vars.locals.environment
  region = local.deployment_vars.locals.region
  provider = local.deployment_vars.locals.provider

  remote_state = local.deployment_vars.locals.remote_state

  provider_config = lookup(local.provider_configs, local.provider)

  provider_configs = {
    aws = <<-EOP
%{ if local.remote_state.backend == "s3" || local.provider != "aws" }
provider "aws" {
  region = "${local.region}"
  skip_get_ec2_platforms     = true
  skip_metadata_api_check    = true
  skip_region_validation     = true
  skip_requesting_account_id = true
}
%{ endif }
EOP
    azure_provider = ""
    gcp_provider = ""
    do_provider = ""
    packet_provider = ""
    cloudflare_provider = ""
  }

}
