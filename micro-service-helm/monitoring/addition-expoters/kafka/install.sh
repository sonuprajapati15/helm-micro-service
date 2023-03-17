#!/usr/bin/env sh

WORKDIR="$(pwd)"
DEVIDE_PATH=${WORKDIR##*/}
CRD="nginx-proxy"

if [ $DEVIDE_PATH != $CRD ]; then
  WORKDIR="${WORKDIR}/${CRD}"
fi

echo "installing nginx-proxy ${WORKDIR}."
kubectl apply -f $WORKDIR/

echo "successfully installed nginx-proxy in namespace monitoring"
echo "......"
echo "......"
echo "......"
echo "......"
echo "you can install nginx-proxy expoter. "

kubectl -n monitoring get pods