variable "my_ip" {
  description = "Your current public IP address"
  type        = string
}

variable "aws_region" {
  default = "eu-west-3"
}

variable "aws_az" {
  default = "eu-west-3a"
}

variable "my_ip" {
  description = "Your public IP with /32"
  type        = string
}

variable "public_key_path" {
  description = "Path to your SSH public key"
  type        = string
}

variable "instance_type" {
  default = "t3.small"
}