output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.subnet_ids
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "cachet_security_group_id" {
  value = aws_security_group.cachet.id
}
