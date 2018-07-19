#!/bin/bash

set -x

GALERA_CONF=/etc/mysql/galera.conf.d/galera.cnf

NODE_NAME=$(hostname -f)
NODE_ADDRESS=$(hostname --ip-address)
CLUSTER_NAME="${CLUSTER_NAME:-"LOCAL"}"
POD_NAMESPACE="${POD_NAMESPACE:-"default"}"

# Seeds Discovery with KubeDNS
DNS_NAME="${DNS_NAME:-"cluster.local"}"
SEEDS=$(seeds --discovery=kubedns --service="$CLUSTER_NAME.$POD_NAMESPACE.svc.$DNS_NAME")

echo "[Galera] Preparing config for cluster: $CLUSTER_NAME"
sed -i -e "s|^wsrep_node_name[[:space:]]*=.*$|wsrep_node_name = ${NODE_NAME}|" "${GALERA_CONF}"
sed -i -e "s|^wsrep_node_address[[:space:]]*=.*$|wsrep_node_address = ${NODE_ADDRESS}|" "${GALERA_CONF}"
sed -i -e "s|^wsrep_cluster_name[[:space:]]*=.*$|wsrep_cluster_name = ${CLUSTER_NAME}|" "${GALERA_CONF}"
sed -i -e "s|^wsrep_cluster_address[[:space:]]*=.*$|wsrep_cluster_address = gcomm://${SEEDS}|" "${GALERA_CONF}"

if [ -n "$SEEDS" ] && [ "$SEEDS" != "$NODE_NAME" ]; then
    mkdir -p "$DATADIR/mysql"
    echo "[Galera] Joining cluster: $CLUSTER_NAME"
else
    echo "[Galera] Starting new cluster!"
fi
