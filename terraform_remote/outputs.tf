output "vm2_fqdn" {
  value       = aws_instance.vm2-ubu.*.public_dns
}

output "vm3_fqdn" {
  value       = aws_instance.vm3-aws.*.public_dns
}
