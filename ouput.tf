output "ssh_command" {
  description = "SSH command to connect to the EC2 instance with RDP tunnel"
  value       = "ssh -i ~/.ssh/ubuntu-perso-key.pem -L 3389:localhost:3389 ubuntu@${aws_instance.ubuntu.public_ip}"
}

output "ubuntu_password" {
  description = "Generated word-based password for ubuntu user (RDP login)"
  value       = "${random_pet.ubuntu_password.id}${random_integer.password_suffix.result}"
  sensitive   = true
}