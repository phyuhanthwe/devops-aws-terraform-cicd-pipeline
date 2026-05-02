#!bin/bash
sudo apt -y update && upgrade

sudo apt install -y docker.io

sudo systemctl enable docker

sudo usermod -aG docker ubuntu

cd /home/ubuntu

docker pull phyuhan/fast-app:v01

docker run -it --name fastapi-app phyuhan/fastapi-app:v01