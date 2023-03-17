#!/usr/bin/env sh

WORKDIR="$(pwd)"
DEVIDE_PATH=${WORKDIR##*/}
CRD="redis"

if [ $DEVIDE_PATH != $CRD ]; then
  WORKDIR="${WORKDIR}/${CRD}"
fi

echo "installing redis ${WORKDIR}."
kubectl apply -f $WORKDIR/

echo "successfully installed redis in namespace monitoring"
echo "......"
echo "......"
echo "......"
echo "......"
echo "you can install redis expoter. "

kubectl -n monitoring get pods