WORKDIR="$(pwd)"

echo "installing abtesting backend service with dir :: ${WORKDIR}"
helm template $WORKDIR/ -f $WORKDIR/demo-app/config-app.yaml >$WORKDIR/apps/config.yaml | kubectl apply -f $WORKDIR/apps/config.yaml
helm template $WORKDIR/ -f $WORKDIR/demo-app/rbac-app.yaml >$WORKDIR/apps/rbac.yaml | kubectl apply -f $WORKDIR/apps/rbac.yaml
helm template $WORKDIR/ -f $WORKDIR/demo-app/analyzer-app.yaml >$WORKDIR/apps/analyzer.yaml | kubectl apply -f $WORKDIR/apps/analyzer.yaml
helm template $WORKDIR/ -f $WORKDIR/demo-app/gateway-app.yaml >$WORKDIR/apps/gateway.yaml | kubectl apply -f $WORKDIR/apps/gateway.yaml

echo "fetching status of backend service:::: "
kubectl get all

echo "deleting template files"
#rm -rf $WORKDIR/apps
