# CAST AI cluster metrics integration

CAST AI exposes Prometheus [metrics](https://api.dev-master.cast.ai/v1/spec/#/external-kubernetes/PrometheusRawMetrics) api endpoint for integration with your existing Prometheus monitoring stack.

### Setup guide

1. Create readonly CAST AI API key via Console UI.

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

Name  | Type | Description
------------- | ------------- | -------------
castai_autoscaler_agent_snapshots_received_total  | Counter | CAST AI Autoscaler agent snapshots received total
castai_autoscaler_agent_snapshots_processed_total  | Counter | CAST AI Autoscaler agent snapshots processed total
castai_cluster_total_cost_hourly | Gauge | CAST AI cluster total cost hourly

**Example queries:**

Cost per cluster.
```
sum(castai_cluster_total_cost_hourly{}) by (castai_cluster)
```

Received snapshots count.

```
sum(increase(castai_autoscaler_agent_snapshots_received_total{castai_cluster="$cluster"}[5m]))
```

Alert on missing snapshots.
```
absent_over_time(castai_autoscaler_agent_snapshots_received_total{castai_cluster="$cluster"}[5m])
```

NOTE: Replace `$cluster` with existing `castai_cluster` label value.
