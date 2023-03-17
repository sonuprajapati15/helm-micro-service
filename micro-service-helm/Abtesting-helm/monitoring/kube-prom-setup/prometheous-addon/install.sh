#!/usr/bin/env sh

WORKDIR="$(pwd)"
DEVIDE_PATH=${WORKDIR##*/}
CRD="prometheous"

if [ $DEVIDE_PATH != $CRD ]; then
  WORKDIR="${WORKDIR}/${CRD}"
fi

echo "installing promtheous ${WORKDIR}."
kubectl apply -f $WORKDIR/namespace.yaml
kubectl apply -f $WORKDIR/.

echo "successfully installed promtheous in namespace monitoring"
echo "......"
echo "......"
echo "......"
echo "......"
echo "you can install grafana and prometheus with their expoter with he help of operator "

kubectl -n monitoring get pods