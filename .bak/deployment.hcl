locals {
  provider = "aws"
  environment = "prod"
  namespace = "polkadot"

  deployment_id = "1"

  aws_region = "us-east-1"
  region = "us-east-1"

  remote_state = {
    backend = "s3"
    config = {
      encrypt = true
      region = "us-east-1"
      key = "${local.deployment_id}/${local.environment}/${local.region}/${path_relative_to_include()}/terraform.tfstate"
      bucket = "terraform-states-${get_aws_account_id()}"
      dynamodb_table = "terraform-locks-${get_aws_account_id()}"
    }
  }

  extra_vars = {}
}