output "ssh_command" {
  description = "SSH command to connect to the EC2 instance with RDP tunnel"
  value       = "ssh -i ~/.ssh/id_rsa -L 3389:localhost:3389 ubuntu@${aws_instance.ubuntu.public_ip}"
}