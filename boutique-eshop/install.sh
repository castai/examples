#!/bin/bash

set -e

# Wait unit ingress load balancer hostname is assigned.
GSLB_INGRESS_HOSTNAME=""
while true
do
   GSLB_INGRESS_HOSTNAME="$(kubectl get svc -n ingress-nginx -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}')"
   if [ "$GSLB_INGRESS_HOSTNAME" != "" ]; then
     echo "Found ingress hostname $GSLB_INGRESS_HOSTNAME"
     break;
   fi;
   echo "Waiting for ingress load balancer hostname"
   sleep 10
done

# Replace boutique-ingress.yaml hosts with received ingress load balancer hostname.
sed 's/replace-me.onmulti.cloud/'$GSLB_INGRESS_HOSTNAME'/g' boutique-ingress.yaml > boutique-ingress-out.yaml

# Apply kubernetes manifests.
echo "Applying manifests"
kubectl create namespace demo --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n demo -f boutique-eshop.yaml -f boutique-ingress-out.yaml

# Wait until pods are ready.
PODS=$(kubectl get pods -n demo -o name | cut -d'/' -f2)
for POD in ${PODS}; do
    until $(kubectl get pod ${POD} -n demo -o jsonpath='{.status.containerStatuses[0].ready}'); do
        echo "Waiting for ${POD} to start..."
        sleep 5
    done
done

echo "Visit your app at https://$GSLB_INGRESS_HOSTNAME"
