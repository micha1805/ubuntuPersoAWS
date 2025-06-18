#!/bin/bash

# Récupère l'IP publique actuelle
MY_IP=$(curl -s https://api.ipify.org)

# Vérifie le format
if [[ ! $MY_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Erreur : IP invalide détectée ($MY_IP)"
  exit 1
fi

# Écrit dans terraform.tfvars
cat > terraform.tfvars <<EOF
my_ip = "${MY_IP}/32"
public_key_path = "~/.ssh/ubuntu-perso-key.pem"
EOF

echo "✅ terraform.tfvars mis à jour avec IP : ${MY_IP}/32"