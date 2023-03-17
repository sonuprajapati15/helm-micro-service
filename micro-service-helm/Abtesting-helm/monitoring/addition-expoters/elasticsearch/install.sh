#!/usr/bin/env sh

WORKDIR="$(pwd)"
DEVIDE_PATH=${WORKDIR##*/}
CRD="elasticsearch"

if [ $DEVIDE_PATH != $CRD ]; then
  WORKDIR="${WORKDIR}/${CRD}"
fi

echo "installing elasticsearch ${WORKDIR}."
kubectl apply -f $WORKDIR/

echo "successfully installed elasticsearch in namespace monitoring"
echo "......"
echo "......"
echo "......"
echo "......"
echo "you can install elasticsearch expoter. "

kubectl -n monitoring get pods