docker build -t dhino12/karsajobs-ui:latest .

export PASSWORD_DOCKER_HUB=joko_12345
export USERNAME_DOCKER_HUB=dhino12

echo "Logging in to Docker Hub......."
echo $PASSWORD_DOCKER_HUB | docker login -u $USERNAME_DOCKER_HUB --password-stdin

docker push dhino12/karsajobs-ui:latest

echo "Success ......."