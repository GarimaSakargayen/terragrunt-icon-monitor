
//variable "this_db_instance_address" {}
//variable "cachet_db_instance_username" {}
//variable "cachet_db_instance_password" {}

//provider "postgresql" {
//  host     = var.db_host
//  password = var.db_password
//  username = var.db_username
//
//  port            = 5432
//  database        = "cachet"
//  sslmode         = "require"
//  connect_timeout = 15
//}
//
//resource "postgresql_database" "this" {
//  name              = "cachet"
//  owner             = "cachet"
//  lc_collate        = "C"
//  connection_limit  = -1
//  allow_connections = true
//}