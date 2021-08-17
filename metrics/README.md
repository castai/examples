# CAST AI cluster metrics integration

CAST AI exposes Prometheus [remote read](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_read) api endpoint for integration with your existing Prometheus monitoring stack.

## Setup guide

1. Create CAST AI API key via Console UI.

2. Configure Prometheus remote read endpoint:

Replace:
* `{clusterId}` with your cluster UUID.
* `{apiKey}` with your api key.

Using helm chart:
```
server:
  remoteRead:
  - name: castai_remote_read
    url: https://api.cast.ai/v1/kubernetes/external-clusters/{clusterId}/prometheus/read
    headers:
      X-API-Key: {apiKey}
```

Directly changing Prometheus configmap:
```
prometheus.yml: |
  remote_read:
  - name: castai_remote_read
    url: https://api.cast.ai/v1/kubernetes/external-clusters/{clusterId}/prometheus/read
    headers:
      X-API-Key: {apiKey}
```
3. Import CAST AI cluster metrics Grafana dashboard from **./grafana/cluster_metrics.json**
