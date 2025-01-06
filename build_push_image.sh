#!/bin/bash
echo "Building item-app image..."
docker build -t item-app:v1 .

echo "Listing Docker images..."
docker images

echo "Please enter your Docker Hub Username..."
read USERNAME_DOCKER_HUB

echo "Please enter your Docker Hub Password..."
read -s PASSWORD_DOCKER_HUB

echo "Tagging item-app:v1 image for Docker Hub..."
docker tag item-app:v1 $USERNAME_DOCKER_HUB/item-app:v1

# echo "Pulling mongo:3 image..."
docker pull mongo:3

# echo "Creating item-db network..."
docker network create item-db

# echo "Creating app-db volume..."
docker volume create app-db

# echo "Running item-app container..."
docker run -dp 8080:8080 --name item-app -w /app -v "$(pwd):/app" --network item-db -e NODE_ENV=production -e DB_HOST=item-db node:14-alpine sh -c "npm install --unsafe-perm && npm run build && npm start"

# echo "Running MongoDB container..."
docker run -d --name item-db --network item-db --network-alias mongo -v app-db:/data/db -e NODE_ENV=production -e DB_HOST=item-db mongo:3

docker commit item-app items-app
docker commit item-db items-db

docker tag items-app:latest localhost:5000/items-app
docker tag items-db:latest localhost:5000/items-db

docker push localhost:5000/items-db
docker push localhost:5000/items-app

echo "Logging in to Docker Hub..."
echo $PASSWORD_DOCKER_HUB | docker login -u $USERNAME_DOCKER_HUB --password-stdin

echo "Pushing item-app:v1 to Docker Hub..."
docker push $USERNAME_DOCKER_HUB/item-app:v1

echo "Script finished!"