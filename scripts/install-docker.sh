#!bin/bash
sudo apt -y update && upgrade

sudo apt install -y docker.io

sudo systemctl enable docker

sudo usermod -aG docker ubuntu

cd /home/ubuntu

docker pull phyuhan/flask-cicd-demo-app:latest

docker run -it --name flask-app phyuhan/flask-cicd-demo-app:latest