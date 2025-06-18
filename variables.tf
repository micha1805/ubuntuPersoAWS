variable "my_ip" {
  description = "Your public IP with /32"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "aws_az" {
  description = "AWS availability zone"
  type        = string
  default     = "eu-west-3a"
}

variable "public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}
