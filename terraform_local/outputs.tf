output "node_fqdn" {
  value       = aws_instance.vm1-ubu.*.public_dns
  description = "The domain name of the load balancer"
}