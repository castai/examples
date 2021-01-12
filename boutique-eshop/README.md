# Boutique Web Shop with Redis

Sample microservices "Boutique web shop" for deploying on CastAI

1. Create multi-cloud cluster in https://console.cast.ai, ideally with 3 clouds.

2. Copy cluster GSLB DNS which can be found in console UI cluster details page. (eg. 1849464756.cluster-d4846470.local.onmulti.cloud).

3. Create CNAME in your business DNS zone (shop.example.com) which points to GLB DNS Name from step 2. This step is optional and you can
use CAST AI generated DNS.

4. Modify Ingress resource (very last in yaml file) with CNAME from step 3 in file https://raw.githubusercontent.com/CastAI/examples/main/boutique-eshop/boutique-eshop.yaml
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

5. Apply yaml to multi-cloud K8s cluster from step 4

`kubectl apply -f boutique-eshop.yaml`

6. Go to URL https://name created in step 3.

7. Refresh site several times to demonstrate that Front-end PODs are distributed on 3 clouds.

