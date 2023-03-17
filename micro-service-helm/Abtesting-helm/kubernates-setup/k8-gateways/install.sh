#!/usr/bin/env sh

WORKDIR="$(pwd)"

DEVIDE_PATH=${WORKDIR##*/}
CRD="k8-gateways"
if [ $DEVIDE_PATH != $CRD ]; then
  WORKDIR="${WORKDIR}/${CRD}"
fi

echo "Install helm charts"
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
kubectl create namespace istio-system
echo "installing istio/base"
helm upgrade -i istio-base istio/base -n istio-system
echo "installing istio/istio"
helm upgrade -i istiod istio/istiod -n istio-system --wait
helm ls -n istio-system
helm status istiod -n istio-system
kubectl get deployments -n istio-system --output wide
echo "successfully installed istio/base and istiod in namespace istio-system"

echo "Install Istio ingress"
kubectl create namespace istio-ingress
kubectl label namespace istio-ingress istio-injection=enabled
kubectl apply -f $WORKDIR/ingress
echo "fetching status of istio ingress"
kubectl -n istio-ingress get all

echo "Installing gateways for incoming traffic"
kubectl apply -f $WORKDIR/gateways
echo "fetching status of installed gateways"
kubectl -n istio-ingress get gateway

echo "create virtual service which manges the traffic routing"
kubectl apply -f $WORKDIR/virtual-services
echo "fetching status of installed virtual-services"
kubectl -n monitoring get virtualservice
kubectl get virtualservice

echo "successfully installed ingress, gateways, virtual-services, in namespace monitoring"
echo "......"
echo "......"
echo "......"
echo "......"
echo "......"
