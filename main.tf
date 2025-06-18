# main.tf

provider "aws" {
  region = "eu-west-3"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "vpc-ubuntu-perso" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "igw-ubuntu-perso" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-3a"
  tags                    = { Name = "subnet-public-ubuntu-perso" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = { Name = "ubuntu-perso-rt-table" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "rdp_sg" {
  name        = "ubuntu-perso-sg"
  description = "Allow SSH only from my IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "m7i.2xlarge"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.rdp_sg.id]
  key_name               = "ubuntu-perso-key"
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y xfce4 xfce4-goodies xrdp firefox
              echo xfce4-session > /home/ubuntu/.xsession
              chown ubuntu:ubuntu /home/ubuntu/.xsession
              systemctl enable xrdp
              systemctl restart xrdp
              echo "ubuntu:Ubuntu2024" | chpasswd
              chown xrdp:xrdp /etc/xrdp/key.pem
              chown xrdp:xrdp /etc/xrdp/cert.pem
              chmod 600 /etc/xrdp/key.pem
              chmod 644 /etc/xrdp/cert.pem
              EOF

  tags = {
    Name = "ubuntu-perso-rdp"
  }
}

output "public_ip" {
  value = aws_instance.ubuntu.public_ip
}