# Boutique Web Shop with Yugabyte

Sample microservices "Boutique web shop" for deploying on CastAI

1. Create multi-cloud cluster in https://console.cast.ai with GCP, AWS. Use large CAST shape for worker nodes and two for GCP.

2. Copy cluster GSLB DNS which can be found in console UI cluster details page. (eg. 1849464756.cluster-d4846470.local.onmulti.cloud).

3. Create CNAME in your business DNS zone (shop.example.com) which points to GLB DNS Name from step 2. This step is optional and you can
   use CAST AI generated DNS.
   
4. Modify Ingress resource (very last in yaml file) with CNAME from step 3 in file https://raw.githubusercontent.com/CastAI/examples/main/boutique-eshop-yugabyte-dev/boutique-eshop-yb.yaml
```
spec:
  tls:
    - hosts:
        - boutique-demo.onmulti.cloud
      secretName: demo-tls
  rules:
    - host: boutique-demo.onmulti.cloud
```    
Should be
```
spec:
  tls:
    - hosts:
        - shop.example.com
      secretName: demo-tls
  rules:
    - host: shop.example.com
``` 

5. Install Yugabyte DB, Redis tables and Boutique E-shop microservices by running
   `kubectl apply -f https://raw.githubusercontent.com/CastAI/examples/main/boutique-eshop-yugabyte-dev/boutique-eshop-yb.yaml` script.

6. Go to URL https://name created in step 3.

7. Refresh site several times to demonstrate that Front-end PODs are distributed on 3 clouds.

8. Open Yugabyte UI locally using port-forward.
```
kubectl -n yugabyte port-forward svc/yb-masters 7000
```
Yugabyte UI should be available at http://localhost:7000

9. Check on which cloud master leader is running and kill the `yb-master-0` pod.

```
kubectl delete pod yb-master-0 -n yugabyte
```

10. Open Yugabyte UI as in step 8. If it's not working try port-forward to another namespace.

11. Refresh the app. It should continue to be working.

12. After done cleanup demo resources by running ``kubectl delete -f https://raw.githubusercontent.com/CastAI/examples/main/boutique-eshop-yugabyte-dev/boutique-eshop-yb.yaml`` script.
