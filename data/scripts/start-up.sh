#!/bin/bash
echo "running start-up script"
apt-get update -y
apt-get upgrade -y
apt install docker.io -y
gcloud auth configure-docker europe-west1-docker.pkg.dev --quiet
docker pull victorrgez/learningcicd
PROJECT_ID=$(curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
docker tag victorrgez/learningcicd europe-west1-docker.pkg.dev/$PROJECT_ID/docker-repository/learningcicd:1
docker push europe-west1-docker.pkg.dev/$PROJECT_ID/docker-repository/learningcicd:1
echo "finished start-up script"