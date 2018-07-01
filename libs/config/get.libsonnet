{
  "description": "get parameter for configuration",
  "parameters": [
    {
      "name": "key",
      "required": true
    }
  ],
  "script": (importstr '../script/init-environment') + |||
    yq read config/environments/${ENVIRONMENT}.yaml '{{ .key }}'
  |||
}
