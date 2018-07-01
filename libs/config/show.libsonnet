{
  "description": "show parameters for configuration",
  "parameters": [],
  "script": (importstr '../script/init-environment') + |||
    yq -c . config/environments/${ENVIRONMENT}.yaml
  |||
}
