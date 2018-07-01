{
  "description": "get parameter for configuration",
  "parameters": [
    {
      "name": "key",
      "required": true
    }
  ],
  "script": (importstr './init') + |||
    yq delete -i config/environments/${ENVIRONMENT}.yaml '{{ .key }}'
  |||
}
