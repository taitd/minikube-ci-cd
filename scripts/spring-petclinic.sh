#!/bin/bash

#Retrieve the latest git commit hash
TAG=`git rev-parse --short HEAD` 

#Build the docker image
docker build -t 127.0.0.1:30400/spring-petclinic:$TAG -f applications/spring-petclinic/Dockerfile applications/spring-petclinic

#Setup the proxy for the registry
docker stop socat-registry; docker rm socat-registry; docker run -d -e "REGIP=`minikube ip`" --name socat-registry -p 30400:5000 chadmoon/socat:latest bash -c "socat TCP4-LISTEN:5000,fork,reuseaddr TCP4:`minikube ip`:30400"

echo "5 second sleep to make sure the registry is ready"
sleep 5;

#Push the images
docker push 127.0.0.1:30400/spring-petclinic:$TAG

#Stop the registry proxy
docker stop socat-registry

# Create the deployment and service for the spring-petclinic node server
sed 's#127.0.0.1:30400/spring-petclinic:latest#127.0.0.1:30400/spring-petclinic:'$TAG'#' applications/spring-petclinic/k8s/deployment.yaml | kubectl apply -f -
