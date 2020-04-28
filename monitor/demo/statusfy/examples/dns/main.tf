variable "public_key" {}
variable "private_key_path" {}
variable "root_domain_name" {}
variable "hostname" {}


module "this" {
  source = "..\/.."
  private_key_path = var.private_key_path
  public_key = var.public_key

}

output "public_ip" {
  value = module.this.public_ip
}