variable "create" {
  description = "Bool to create all"
  type = bool
  default = true
}

variable "subnet_id" {
  description = "The subnet id to deploy into"
  type = string
}

variable "security_group_id" {
  description = "The sg to deploy into"
  type = string
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

#####
# DNS
#####
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

#########
# Ansible
#########
variable "db_username" {
  description = "the db password"
  type = string
}

variable "db_password" {
  description = "the db password"
  type = string
}

variable "db_host" {
  description = "The host for the db"
  type = string
}

variable "cachet_local_build" {
  description = "Bool to install php for cachet"
  type = bool
  default = false
}

variable "env_file" {
  description = "Path to file for cachet"
  type = string
  default = ""
}