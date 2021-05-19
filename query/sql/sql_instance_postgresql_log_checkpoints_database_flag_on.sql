select
  -- Required Columns
  self_link resource,
  case
    when database_version not like 'POSTGRES%' then 'skip'
    when database_flags @> '[{"name":"log_checkpoints","value":"on"}]' then 'ok'
    else 'alarm'
  end status,
  case
    when database_version not like 'POSTGRES%'
      then title || ' not a PostgreSQL database.'
    when database_flags is null or not (database_flags @> '[{"name":"log_checkpoints"}]')
      then title || ' ''log_checkpoints'' database flag not set.'
    when database_flags @> '[{"name":"log_checkpoints","value":"on"}]'
      then title || ' ''log_checkpoints'' database flag set to ''on''.'
    else title || ' ''log_checkpoints'' database flag set to ''off''.'
  end reason,
  -- Additional Dimensions
  location,
  project
from
  gcp_sql_database_instance;