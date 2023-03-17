#!/usr/bin/env sh

WORKDIR="$(pwd)"

kubectl label namespace default istio-injection=enabled
echo "installing fluentd for logging"
./fluentd/install.sh
echo "successfully !!!!!!"

echo "installing grafana "
./grafana/install.sh
echo "successfully !!!!!!"

echo "installing k8 istio ingress, gateways, virtual services "
./k8-gateways/install.sh
echo "successfully !!!!!!"

echo "installing kiali "
./kiali/install.sh
echo "successfully !!!!!!"

echo "installing kibana "
./kibana/install.sh
echo "successfully !!!!!!"

echo "installing kong admin ui "
./konga-ui/install.sh
echo "successfully !!!!!!"

echo "installing prometheous admin ui "
./prometheous/install.sh
echo "successfully !!!!!!"
