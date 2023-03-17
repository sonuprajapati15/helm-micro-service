#!/usr/bin/env sh

WORKDIR="$(pwd)"

DEVIDE_PATH=${WORKDIR##*/}
CRD="konga-ui"
if [ $DEVIDE_PATH != $CRD ]; then
  WORKDIR="${WORKDIR}/${CRD}"
fi

echo "installing konga admin ui "
kubectl apply -f $WORKDIR/.

echo "successfully installed konga admin ui in namespace monitoring"
echo "......"
echo "......"
echo "......"
echo "......"
echo "......"

kubectl -n monitoring get pods
