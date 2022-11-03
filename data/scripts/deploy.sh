#!/bin/bash
# Deploys the image inside a VM
echo "running start-up script"
apt-get update -y
apt-get upgrade -y
apt install docker.io -y
gcloud auth configure-docker europe-west1-docker.pkg.dev --quiet
PROJECT_ID=$(curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
docker run -d --name calculator -p 0.0.0.0:5000:5000 europe-west1-docker.pkg.dev/$PROJECT_ID/docker-repository/learningcicd:1
echo "INSTANCE is UP"