#!/usr/bin/env sh

WORKDIR="$(pwd)"

DEVIDE_PATH=${WORKDIR##*/}
CRD="kibana"
if [ $DEVIDE_PATH != $CRD ]; then
  WORKDIR="${WORKDIR}/${CRD}"
fi

echo "installing kibana "
kubectl apply -f $WORKDIR/namespace.yaml
kubectl apply -f $WORKDIR/kibana.yaml

echo "successfully installed kibana in namespace monitoring"
echo "......"
echo "......"
echo "......"
echo "......"
echo "......"

kubectl -n monitoring get pods
