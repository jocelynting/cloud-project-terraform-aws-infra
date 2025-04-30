output "webapp_public_ip" {
  description = "Public IP of WebApp"
  value       = [for instance in aws_instance.webapp_instance : instance.public_ip]
}