#!/bin/bash
set -e

echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

for i in {1..5}; do
  sudo apt-get update -y && break
  sleep 5
done

sudo apt-get install -y docker.io

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ubuntu

cd /home/ubuntu

# Set up the repository
sudo apt install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Compose Pulgin
for i in {1..5}; do
  sudo apt update -y && break || sleep 5
done
sudo apt install -y docker-compose-plugin

# Clone Docker project
git clone https://github.com/phyuhanthwe/app-docker.git
cd app-docker

# Run everything
sudo docker compose up -d