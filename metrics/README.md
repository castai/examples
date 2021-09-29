# CAST AI cluster metrics integration

CAST AI exposes Prometheus [metrics](https://api.dev-master.cast.ai/v1/spec/#/external-kubernetes/PrometheusRawMetrics) api endpoint for integration with your existing Prometheus monitoring stack.

### Setup guide

1. Create CAST AI API key via Console UI.

2. Configure Prometheus scrape job:

Replace:
* `{apiKey}` with your api key.


```yaml
scrape_configs:
  - job_name: 'castai_cluster_metrics'
    scrape_interval: 10s
    scheme: https
    static_configs:
      - targets: ['api.cast.ai']
    metrics_path: '/v1/kubernetes/external-clusters/prometheus/metrics'
    authorization:
      type: 'Token'
      credentials: '{apiKey}'

```


### Metrics types

Name  | Description
------------- | -------------
castai_autoscaler_agent_snapshots_received_total  | CAST AI Autoscaler agent snapshots received total 
castai_autoscaler_agent_snapshots_processed_total  | CAST AI Autoscaler agent snapshots processed total
