{
  "description": "show parameters for configuration",
  "parameters": [],
  "script": (importstr '../script/init-environment') + |||
    cat config/environments/${ENVIRONMENT}.yaml
  |||
}
