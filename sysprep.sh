#!/bin/sh

echo "Step 1 - Uninstall Any Existing Versions Of Docker Engine"
sudo snap remove docker

echo "Step 2 - Adding Required Docker Runtime GPG Keys And Repositories"
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "Step 3 - Installing Docker Engine"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Step 4 - Pulling And Running Docker Flamenco Image"
sudo mkdir /mnt/flamencoData
sudo docker run -d --name flamenco -p 8080:8080 -p 1900:1900 -p 5000:5000 -v /mnt/flamencoData:/mnt/flamencoData tpeppy/flamenco
