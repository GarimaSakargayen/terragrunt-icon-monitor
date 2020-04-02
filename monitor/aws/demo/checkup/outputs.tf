output "private_ip" {
  value = aws_instance.this.public_ip
}

output "public_ip" {
  value = aws_eip.public_ip.public_ip
}

