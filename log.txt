#!/bin/bash
echo "Building item-app image..."
docker build -t item-app:v1 .

echo "Listing Docker images..."
docker images

echo "==== Make sure there is a repository called 'item-app' in your DockerHub ===="
echo "Please enter your Docker Hub Username..."
read USERNAME_DOCKER_HUB

echo "Please enter your Docker Hub Password..."
read -s PASSWORD_DOCKER_HUB

echo "Tagging item-app:v1 image for Docker Hub..."
docker tag item-app:v1 $USERNAME_DOCKER_HUB/item-app:v1

echo "Logging in to Docker Hub..."
echo $PASSWORD_DOCKER_HUB | docker login -u $USERNAME_DOCKER_HUB --password-stdin

echo "Pushing item-app:v1 to Docker Hub..."
docker push $USERNAME_DOCKER_HUB/item-app:v1

echo "Script finished!"