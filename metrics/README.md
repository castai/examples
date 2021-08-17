# CAST AI cluster metrics integration

CAST AI exposes Prometheus [remote read](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_read) api endpoint for integration with your existing Prometheus monitoring stack.

### Setup guide

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
3. Import CAST AI cluster metrics Grafana dashboard from [grafana/cluster_metrics.json](https://github.com/castai/examples/blob/main/metrics/grafana/cluster_metrics.json)


### Metrics types

Name  | Description
------------- | -------------
castai_autoscaler_agent_snapshots_received_total  | CAST AI Autoscaler agent snapshots received total 
castai_autoscaler_agent_snapshots_processed_total  | CAST AI Autoscaler agent snapshots processed total
castai_autoscaler_node_placer_unscheduled_pods_total | CAST AI Autoscaler node placer unscheduled pods total
castai_spot_interrupts_total | CAST AI Provisioner spot interrupts total
castai_add_node_op_total | CAST AI Provisioner add node operations total
castai_delete_node_op_total | CAST AI Provisioner delete node operations total
castai_add_node_op_failures_total | CAST AI Provisioner add node operations total
castai_delete_node_op_failures_total | CAST AI Provisioner delete node operations total
