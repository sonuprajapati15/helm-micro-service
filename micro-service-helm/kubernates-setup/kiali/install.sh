# #!/usr/bin/env sh

# WORKDIR="$(pwd)"

# DEVIDE_PATH=${WORKDIR##*/}
# CRD="kiali"
# if [ $DEVIDE_PATH != $CRD ]; then
#   WORKDIR="${WORKDIR}/${CRD}"
# fi

# echo "installing kiali "
# kubectl apply -f $WORKDIR/namespace.yaml
# kubectl apply -f $WORKDIR/.

# echo "successfully installed kiali in namespace monitoring"
# echo "......"
# echo "......"
# echo "......"
# echo "......"
# echo "......"

# kubectl -n monitoring get pods
