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