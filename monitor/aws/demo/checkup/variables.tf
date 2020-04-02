variable "create" {}

########
# Label
########
variable "name" {
  description = "The name for the label"
  type        = string
  default     = "prep"
}

variable "environment" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace to deploy into"
  type        = string
  default     = "prod"
}

variable "stage" {
  description = "The stage of the deployment"
  type        = string
  default     = "blue"
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = "testnet"
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = ""
}
