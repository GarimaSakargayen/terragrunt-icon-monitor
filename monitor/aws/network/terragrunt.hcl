terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
}

inputs = {}

