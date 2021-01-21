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

echo "Waiting for pods to start"
kubectl wait --timeout="300s" --for=condition=Ready pods --all -n demo

echo "Visit your app at https://$GSLB_INGRESS_HOSTNAME"
