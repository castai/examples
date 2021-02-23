# Boutique Web Shop with Yugabyte

Sample microservices "Boutique web shop" for deploying on CastAI

1. Create multi-cloud cluster in https://console.cast.ai in one or more Clouds. If starting with starter Cluster configuration, enable UnscheduledPod policy or add additional node

2. Clone this repo locally and navidate to directory boutique-eshop-yugabyte-dev

3. Install Yugabyte DB, Redis tables 
   `kubectl apply -f 1-namespaces.yaml`
   and
   `kubectl apply -f 2-distributed-database-AWS-AZ-GCP.yaml`

4. Install Boutique E-shop microservices
   `kubectl apply -f 3-boutique-app-more-replicas.yaml`

5. Copy cluster GSLB DNS, which can be found in console UI cluster details page. (eg. 1849464756.cluster-d4846470.local.onmulti.cloud) and replace it in 4-ingress.yaml with your cluster GSLB record, or you can add your own DNS CNAME record name that points to this GSLB DNS record.

6. Install ingress service
   `kubectl apply -f 3-boutique-app-more-replicas.yaml`
   
7. Go to URL https://URL copied from step 5.

8. Refresh site several times to demonstrate that Front-end PODs are distributed on 3 clouds.

9. Open Yugabyte UI locally using port-forward.
```
kubectl -n yugabyte port-forward svc/yb-masters 7000
```
Yugabyte UI should be available at http://localhost:7000

10. After done cleanup demo resources by running ``kubectl delete -f .`` .
