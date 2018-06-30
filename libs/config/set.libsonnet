{
  "description": "set parameter for configuration",
  "parameters": [
    {
      "name": "key",
      "required": true
    },
    {
      "name": "value",
      "required": true
    }
  ],
  "script": (importstr './init') + |||
    yq write -i config/environments/${ENVIRONMENT}.yaml '{{ .key }}' {{ .value }}
    cat config/environments/${ENVIRONMENT}.yaml
  |||
}
