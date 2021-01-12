#!/bin/bash

set -e

echo 'Creating namespaces'
kubectl create namespace yugabyte-aws --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace yugabyte-gcp --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace yugabyte-do --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace boutique --dry-run=client -o yaml | kubectl apply -f -

echo 'Deploying Yugabyte'
kubectl -n yugabyte-aws apply -f ./yugabyte/aws-out.yaml
kubectl -n yugabyte-gcp apply -f ./yugabyte/gcp-out.yaml
kubectl -n yugabyte-do apply -f ./yugabyte/do-out.yaml

sleep 10

until $(kubectl get pod yb-master-0 -n yugabyte-aws -o jsonpath='{.status.containerStatuses[0].ready}'); do
    echo "Waiting for yb-master-0 aws pod to start..."
    sleep 5
done

until $(kubectl get pod yb-master-0 -n yugabyte-gcp -o jsonpath='{.status.containerStatuses[0].ready}'); do
    echo "Waiting for yb-master-0 gcp pod to start..."
    sleep 5
done

until $(kubectl get pod yb-master-0 -n yugabyte-do -o jsonpath='{.status.containerStatuses[0].ready}'); do
    echo "Waiting for yb-master-0 do pod to start..."
    sleep 5
done

sleep 10

echo 'Setup Yugabyte Redis table'
kubectl exec -it yb-master-0 -n yugabyte-aws -- /home/yugabyte/bin/yb-admin --master_addresses "yb-master-0.yb-masters.yugabyte-aws.svc.cluster.local:7100,yb-master-0.yb-masters.yugabyte-gcp.svc.cluster.local:7100,yb-master-0.yb-masters.yugabyte-do.svc.cluster.local:7100" setup_redis_table

echo 'Installing boutique microservices'
kubectl -n boutique apply -f ./boutique-eshop.yaml
