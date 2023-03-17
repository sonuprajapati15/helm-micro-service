#!/usr/bin/env sh

WORKDIR="$(pwd)"
DEVIDE_PATH=${WORKDIR##*/}
CRD="postgres"

if [ $DEVIDE_PATH != $CRD ]; then
  WORKDIR="${WORKDIR}/${CRD}"
fi

echo "installing postgres ${WORKDIR}."
kubectl apply -f $WORKDIR/

echo "successfully installed postgres in namespace monitoring"
echo "......"
echo "......"
echo "......"
echo "......"
echo "you can install postgres expoter. "

kubectl -n monitoring get pods