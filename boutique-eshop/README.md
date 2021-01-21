# Boutique Web Shop with Redis

Sample microservices "Boutique web shop" for deploying on CastAI

1. Create multi-cloud cluster in https://console.cast.ai.

2. Copy cluster GSLB DNS which can be found in console UI cluster details page. (eg. 1849464756.cluster-d4846470.local.onmulti.cloud).

3. Modify Ingress resource `boutique-ingress.yaml` with CNAME from step 2.
```
spec:
  tls:
    - hosts:
        - replace-me.onmulti.cloud
      secretName: demo-tls
  rules:
    - host: replace-me.onmulti.cloud
```    
Should be
```
spec:
  tls:
    - hosts:
        - 1849464756.cluster-d4846470.local.onmulti.cloud
      secretName: demo-tls
  rules:
    - host: 1849464756.cluster-d4846470.local.onmulti.cloud
``` 

4. Deploy to multi-cloud K8s cluster.

Create namespace:
```
kubectl create ns demo
```

Apply manifests:
```
kubectl apply -n demo -f boutique-eshop.yaml -f boutique-ingress.yaml
```

5. Go to URL https://name created in step 2.

6. Refresh site several times to demonstrate that Front-end PODs are distributed on 3 clouds.

