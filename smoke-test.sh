#!/bin/bash

docker logout
docker login --username ensanguine

# Pull the image from Docker Hub
docker pull ensanguine/simple-crm-lite:latest

# Stop any running containers from previous lessons
docker compose down

# Run just the database
docker run -d \
  --name simple-crm-db \
  -e POSTGRES_DB=simplecrmlite \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5433:5432 \
  postgres:16-alpine



# Wait 5 seconds for database to start
sleep 5

# Run the app (using image from Docker Hub)
docker run -d \
  --name simple-crm-app \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5433/simplecrmlite \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=postgres \
  ensanguine/simple-crm-lite:latest

# Wait 10 seconds for app to start
sleep 10

# Test it
curl http://localhost:8080/customers
printf "\n"