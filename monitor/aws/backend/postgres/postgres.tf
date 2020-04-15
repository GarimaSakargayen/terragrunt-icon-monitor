variable "password" {}
variable "username" {}
variable "host" {}

provider "postgresql" {
  host            = var.host
  port            = 5432
  database        = "cachet"
  username        = var.username
  password        = var.password
  sslmode         = "require"
  connect_timeout = 15
}

resource "postgresql_database" "my_db" {
  name              = "cachet"
  owner             = "my_role"
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
}