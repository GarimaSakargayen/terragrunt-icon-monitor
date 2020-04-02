variable "public_key" {}
variable "private_key_path" {}

module "this" {
  source = "../.."
  private_key_path = var.private_key_path
  public_key = var.public_key
}