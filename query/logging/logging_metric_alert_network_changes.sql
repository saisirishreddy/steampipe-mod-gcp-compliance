with filter_data as (
  select
    display_name alert_name,
    m.name metric_name
  from
    gcp_monitoring_alert_policy,
    jsonb_array_elements(conditions) as filter_condition
    join gcp_logging_metric m on m.filter ~ '\s*resource.type\s*=\s*gce_network\s*AND\s*protoPayload.methodName\s*=\s*"beta.compute.networks.insert"\s*OR\s*protoPayload.methodName\s*=\s*"beta.compute.networks.patch"\s*OR\s*protoPayload.methodName\s*=\s*"v1.compute.networks.delete"\s*OR\s*protoPayload.methodName\s*=\s*"v1.compute.networks.removePeering"\s*OR\s*protoPayload.methodName\s*=\s*"v1.compute.networks.addPeering"\s*'
    and filter_condition -> 'conditionThreshold' ->> 'filter' like '%metric.type="' || m.metric_descriptor_type || '"%'
  where
    enabled
)
select
  -- Required Columns
  project resource,
  case
    when (select count(metric_name) from filter_data) > 0 then 'ok'
    else 'alarm'
  end status,
  case
    when (select count(metric_name) from filter_data) > 0
      then 'Log metric and alert exist for network changes.'
    else 'Log metric and alert do not exist for network changes.'
  end reason,
  -- Additional Dimensions
  project
from
  gcp_iam_policy;