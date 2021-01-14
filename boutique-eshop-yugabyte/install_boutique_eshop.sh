#!/bin/bash

set -e

kubectl create namespace boutique --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f ./boutique-eshop.yaml -n boutique
