#!/usr/bin/env sh

## build docker image with plugins for our purpose
WORKDIR="`pwd`"

echo "initiating monitoring compnents in namespace monitoring "
echo "intiating setup for monitoring........"
kubectl apply -f $WORKDIR/setup/
echo "set completed........"
echo "installing prometheous-addon "
kubectl apply -f $WORKDIR/kube-prom-setup/prometheous-addon/
echo "prometheous-addon installed ........"
echo "installing prometheus "
kubectl apply -f $WORKDIR/kube-prom-setup/prometheus/
echo "prometheus installed ........"
echo "installing blackbox "
kubectl apply -f $WORKDIR/kube-prom-setup/blackbox/
echo "blackbox installed ........"
echo "installing kube-state-metrics "
kubectl apply -f $WORKDIR/kube-prom-setup/kube-state-metrics/
echo "kube-state-metrics installed ........"
echo "installing node-expoter "
kubectl apply -f $WORKDIR/kube-prom-setup/node-expoter/
echo "node-expoter installed ........"
echo "installing alert manager"
kubectl apply -f $WORKDIR/kube-prom-setup/alert-manager/
echo "alert manager installed ........"
echo "installing grafana "
kubectl apply -f $WORKDIR/kube-prom-setup/grafana/
echo "grafana installed ........"

echo "installing addon expoters "
echo "installing elasticsearch expoter "
kubectl apply -f $WORKDIR/addition-expoters/elasticsearch/
echo "elasticsearch expoter installed ........"
echo "installing kafka expoter "
kubectl apply -f $WORKDIR/addition-expoters/kafka/
echo "kafka expoter installed ........"
echo "installing nginx-proxy expoter "
kubectl apply -f $WORKDIR/addition-expoters/nginx-proxy
echo "nginx-proxy expoter installed ........"
echo "installing postgres expoter "
kubectl apply -f $WORKDIR/addition-expoters/postgres/
echo "postgres expoter installed ........"
echo "installing redis expoter "
kubectl apply -f $WORKDIR/addition-expoters/redis/
echo "redis expoter installed ........"

kubectl -n monitoring get all

