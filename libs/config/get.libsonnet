{
  "description": "get parameter for configuration",
  "parameters": [
    {
      "name": "key",
      "required": true
    }
  ],
  "script": (importstr './init') + |||
    yq read config/environments/${ENVIRONMENT}.yaml '{{ .key }}'
  |||
}
