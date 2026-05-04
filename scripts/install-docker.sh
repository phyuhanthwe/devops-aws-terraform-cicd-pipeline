#!bin/bash
sudo apt -y update && upgrade

sudo apt install -y docker.io

sudo systemctl enable docker

sudo usermod -aG docker ubuntu

cd /home/ubuntu

docker pull phyuhan/fastapi-app:latest

docker stop fastapi-app01 || true
docker rm fastapi-app01 || true

docker run -d --name fastapi-app01 -p 80:8000 phyuhan/fastapi-app:latest