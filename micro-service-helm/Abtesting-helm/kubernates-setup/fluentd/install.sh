#!/usr/bin/env sh

## build docker image with plugins for our purpose
WORKDIR="`pwd`"
GCP_PROJECT="project-jiomarket-non-prod"

DEVIDE_PATH=${WORKDIR##*/}
CRD="fluentd"
if [ $DEVIDE_PATH != $CRD ]
then
  WORKDIR="${WORKDIR}/${CRD}"
fi

echo "initiating fluentd "
echo "building image with name:: asia-south1-docker.pkg.dev/${GCP_PROJECT}/ab-testing/fluentd  and tag:: latest"
docker build -t asia-south1-docker.pkg.dev/$GCP_PROJECT/ab-testing/fluentd:latest $WORKDIR/dockerfiles/
echo "pushing image with name:: asia-south1-docker.pkg.dev/${GCP_PROJECT}/ab-testing/fluentd  and tag:: latest to the project:: ${GCP_PROJECT}"
docker push asia-south1-docker.pkg.dev/$GCP_PROJECT/ab-testing/fluentd:latest
echo "image asia-south1-docker.pkg.dev/${GCP_PROJECT}/ab-testing/fluentd successfully pushed"

echo "installing fluentd in namespace fluentd"
kubectl apply -f $WORKDIR/namespace.yaml
kubectl apply -f $WORKDIR/.

echo "successfully installed fluentd in namespace fluentd"
echo "......"
echo "......"
echo "......"
echo "......"
echo "......"

kubectl -n fluentd get pods

