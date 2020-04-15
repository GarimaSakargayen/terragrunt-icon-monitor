module "vpc" {
  source = "github.com/insight-infrastructure/terraform-aws-default-vpc.git?ref=v0.1.0"
}

module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"

  name = var.name

  tags = {
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
}

resource "aws_security_group" "cachet" {
  vpc_id = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = [
      22,   # ssh
      80,
      443,
      //      9100, # node exporter
      //      9115, # blackbox exporter
      //      8080, # cadvisor
    ]

    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds" {
  vpc_id = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = [
      5432,   # pg
    ]

    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      security_groups = [aws_security_group.cachet.id]
    }
  }

//  TODO -> RM
  ingress {
    from_port = 5432
    protocol = "tcp"
    to_port = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}


