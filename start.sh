#!/bin/bash

set -e

prepare() {
eval $(minikube docker-env)
echo "[INFO]: Logged into the minikube docker environment";

docker build -t flask-app:local .

echo "[Success]: Image successfully builded";

runmyapp
}

runmyapp(){
sleep 2s;
echo "[INFO]: Adding helm elastic repository at local";
helm repo add elastic https://helm.elastic.co
helm install elasticsearch elastic/elasticsearch --version 7.17.3 -f helm-charts/elasticsearch/values.yaml
printf "\n"
echo "[Success]: Elasticsearch Deployed"
sleep 2s;
echo "[INFO]: Enabling Addon Ingress for Minikube";
minikube addons enable ingress
echo "[INFO]: Starting the Application using Helm";
helm install app -f helm-charts/app/values.yaml ./helm-charts/app
sleep 2s;
printf "\n"
echo "[Success]: App Deployed";
printf "\n\n"
kubectl get pods
printf "\n"
echo "Minikube IP = `minikube ip`"
printf "\n"
echo "[INFO] Run following command to insert the first data into Elasticsearch once both the service Ready (This may take ~ 1 Minute)"
printf "\n"
echo "********************************************************************************************"
echo "curl -X POST -F 'id=1' -F 'cityname=newyork' -F 'population=1000043' `minikube ip`/add_city"
echo "********************************************************************************************"
printf "\n\n"
echo "[INFO]: Browse http://`minikube ip`/all_city after added the first data"
printf "\n"
}
prepare