variable "create" {
  description = "Bool to create all"
  type = bool
  default = true
}

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

variable "private_key_path" {
  description = "Path to the private ssh key"
  type        = string
}

variable "public_key" {
  description = "Public ssh key"
  type        = string
}

variable "root_domain_name" {
  description = "The root domain"
  type = string
  default = ""
}

variable "hostname" {
  description = "hostname for A record - blank to not create record at all"
  type = string
  default = ""
}