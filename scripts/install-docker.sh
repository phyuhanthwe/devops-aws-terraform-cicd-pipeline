#!/bin/bash
set -e

# Update system
for i in {1..3}; do
  sudo apt update -y && sudo apt upgrade -y && break || sleep 3
done

sudo apt-get install -y docker.io

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ubuntu

cd /home/ubuntu

# Create docker-compose.yml
cat <<EOF > docker-compose.yml
services:
  db:
    image: postgres:16
    ports:
      - 5432:5432
    restart: always
    environment:
      - POSTGRES_DB=appdb
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    volumes:
      - postgres_data:/var/lib/postgresql
    container_name: postgres_db

  fastapi-app:
    image: phyuhan/fastapi-app:latest
    ports:
      - 80:8000
    restart: unless-stopped
    environment:
      - DB_HOST=db
      - DB_NAME=appdb
      - DB_USER=postgres
      - DB_PASSWORD=postgres
      - DB_PORT=5432
    depends_on:
      - db
    command: ["python", "-m", "app.main"]
    container_name: fastapi-app
      
volumes:
  postgres_data:
EOF

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

# Run everything
sudo docker compose up -d