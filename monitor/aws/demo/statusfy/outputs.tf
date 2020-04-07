output "private_ip" {
  value = aws_instance.this.private_ip
}

output "public_ip" {
  value = aws_eip.this.public_ip
}

output "fqdn" {
  value = join("", aws_route53_record.this.*.fqdn)
}
