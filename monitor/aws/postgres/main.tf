
variable "rds_admin_user" {}
variable "rds_admin_password" {}
variable "db_host" {}
variable "cachet_password" {}
variable "cachet_username" {}
variable "airflow_db" {}

provider "postgresql" {
  host            = var.db_host
  port            = 5432
  username        = var.rds_admin_user
  password        = var.rds_admin_password
  superuser = false
}

resource "postgresql_role" "cachet_role" {
  name     = var.cachet_username
  login    = true
  password = var.cachet_password
}

resource "postgresql_database" "cachet_db" {
  name              = var.airflow_db
  owner             = postgresql_role.cachet_role.name
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
}

