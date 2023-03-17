WORKDIR="$(pwd)"

echo "installing abtesting backend service with dir :: ${WORKDIR}"
helm template $WORKDIR/ -f $WORKDIR/demo-app/ui-app.yaml >$WORKDIR/apps/abtesting-ui.yaml | kubectl apply -f $WORKDIR/apps/abtesting-ui.yaml

echo "fetching status of backend service:::: "
kubectl get all

echo "deleting template files"
#rm -rf $WORKDIR/apps
