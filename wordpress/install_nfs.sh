#!/bin/bash
helm template stable/nfs-server-provisioner --namespace=nfs-provisioner --set=persistence.enabled=true,persistence.storageClass=cast-block-storage,persistence.size=20Gi,storageClass.name=nfs-storage,storageClass.provisionerName=nfs --generate-name
