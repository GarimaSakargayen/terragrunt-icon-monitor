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