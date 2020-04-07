output "private_ip" {
  value = join("", aws_instance.this.*.private_ip)
}

output "public_ip" {
  value = join("", aws_instance.this.*.public_ip)
}

output "fqdn" {
  value = join("", aws_route53_record.hostname.*.fqdn)
}
