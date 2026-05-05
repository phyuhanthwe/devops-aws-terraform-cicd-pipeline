#!/bin/bash
sudo apt update -y
sudo apt upgrade -y

sudo apt install -y docker.io

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

#install docker-compose 
sudo apt install -y docker-compose

# Run everything
docker-compose up -d