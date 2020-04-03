resource "random_pet" "this" {
  length = 2
}

module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"

  name = var.name

  tags = {
    NetworkName = var.network_name
    Owner       = var.owner
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
}

module "default_vpc" {
  source = "github.com/insight-infrastructure/terraform-aws-default-vpc.git?ref=v0.1.0"
}

resource "aws_security_group" "this" {
  vpc_id = module.default_vpc.vpc_id

  dynamic "ingress" {
    for_each = [
      22,   # ssh
      80, # grpc
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

data "aws_caller_identity" "this" {}

resource "aws_s3_bucket" "backend" {
  count  = var.create ? 1 : 0
  bucket = "logs-${data.aws_caller_identity.this.account_id}"
  acl    = "private"
  tags   = module.label.tags
}

module "ami" {
  source = "github.com/insight-infrastructure/terraform-aws-ami.git?ref=v0.1.0"
}

resource "aws_key_pair" "this" {
  public_key = var.public_key
}

resource "aws_instance" "this" {
  ami           = module.ami.ubuntu_1804_ami_id
  instance_type = "t2.small"

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  subnet_id              = module.default_vpc.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.this.id]

  iam_instance_profile = join("", aws_iam_instance_profile.this.*.id)
  key_name             = aws_key_pair.this.*.key_name[0]
}

resource "aws_eip" "this" {}

resource "aws_eip_association" "main_ip" {
  instance_id = join("", aws_instance.this.*.id)
  public_ip   = aws_eip.this.public_ip
}

module "ansible" {
  source           = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=v0.10.0"
  ip               = join("", aws_eip.this.*.public_ip)
  user             = "ubuntu"
  private_key_path = var.private_key_path

  playbook_file_path = "${path.module}/ansible/main.yml"
  playbook_vars = {}

  requirements_file_path = "${path.module}/ansible/requirements.yml"
}

data "aws_route53_zone" "this" {
  count = var.hostname != "" && var.root_domain_name != "" ? 1 : 0
  name  = "${var.root_domain_name}."
}

resource "aws_route53_record" "this" {
  count = var.hostname != "" && var.root_domain_name != "" ? 1 : 0
  zone_id = join("", data.aws_route53_zone.this.*.zone_id)

  name    = "${var.hostname}.${var.root_domain_name}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.this.public_ip]

  depends_on = [module.ansible]
}