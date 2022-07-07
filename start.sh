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
echo "[Success]: Elasticsearch Deployed"
sleep 2s;
echo "[INFO]: Enabling Addon Ingress for Minikube";
minikube addons enable ingress
echo "[INFO]: Starting the Application using Helm";
helm install app -f helm-charts/app/values.yaml ./helm-charts/app
sleep 2s;
echo "[Success]: App Deployed";
printf "\n\n"
echo "[Success]: Browse http://`minikube ip`"
printf "\n\n"
}
prepare