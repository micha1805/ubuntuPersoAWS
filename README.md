# Ubuntu RDP sur AWS avec Terraform

Ce projet Terraform déploie une instance Ubuntu 24.04 LTS sur AWS configurée comme un poste de travail distant avec une interface graphique XFCE, un serveur XRDP, et le navigateur Firefox. L’accès se fait en toute sécurité via Microsoft Remote Desktop (RDP), en passant par un tunnel SSH (le port 3389 n’est jamais exposé publiquement).

## Fonctionnalités

- Création complète de l’infrastructure AWS :
  - VPC, subnet public, Internet Gateway, route table, Security Group
  - Instance EC2 Ubuntu 24.04 avec IP publique
- Interface graphique XFCE4 + serveur XRDP
- Firefox installé automatiquement
- Aucune exposition directe du port RDP : le flux passe par un tunnel SSH sécurisé

## Prérequis

- Terraform installé localement
- Un compte AWS avec credentials configurés (`aws configure`)
- Une clé SSH dans `~/.ssh/ubuntu-perso-key.pem`
- Microsoft Remote Desktop (macOS, Windows ou Remmina sur Linux)

## Étapes d’utilisation

1. Mettre à jour automatiquement l’adresse IP :
   Lance le script :
   ./update-ip.sh

   Ce script écrit ton IP publique au format X.X.X.X/32 et le chemin vers ta clé SSH dans `terraform.tfvars`.

2. Initialiser le projet :
   terraform init

3. Déployer l’infrastructure :
   terraform apply

   À la fin, Terraform affichera :
   - l’IP publique de ton instance
   - la commande SSH à exécuter pour établir le tunnel

4. Établir la connexion RDP :
   Dans un terminal local, exécute la commande fournie (exemple) :
   ssh -i ~/.ssh/id_rsa -L 3389:localhost:3389 ubuntu@<IP_PUBLIQUE>

   Puis dans Microsoft Remote Desktop :
   - PC name : localhost:3389
   - User : ubuntu
   - Password : Ubuntu2024
   - Gateway : (laisser vide)

   Tu devrais voir apparaître un bureau Ubuntu complet (XFCE) dans une fenêtre distante.

## Nettoyage

Pour tout supprimer proprement :
terraform destroy

## Remarques

- Le port 3389 (RDP) n’est jamais ouvert : seul SSH (port 22) est autorisé depuis ton IP.
- Le mot de passe initial de l’utilisateur `ubuntu` est défini à `Ubuntu2024` (modifiable ensuite).
- Tout est préconfiguré via cloud-init (user_data.sh) : installation de xrdp, xfce4, Firefox et configuration du mot de passe.

## Sécurité

Seul le port SSH est exposé, et uniquement à l’adresse IP renseignée dans `terraform.tfvars`. Le tunnel SSH encapsule tout le trafic RDP. Aucun port Windows typique n’est accessible directement.

## Contact

Projet conçu pour une utilisation simple, sécurisée et reproductible d’un bureau distant Ubuntu sur AWS via Terraform.