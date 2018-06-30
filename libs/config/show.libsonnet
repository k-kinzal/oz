{
  "description": "show parameters for configuration",
  "parameters": [],
  "script": (importstr './init') + |||
    cat config/environments/${ENVIRONMENT}.yaml
  |||
}
