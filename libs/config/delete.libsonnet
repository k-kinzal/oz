{
  "description": "get parameter for configuration",
  "parameters": [
    {
      "name": "key",
      "required": true
    }
  ],
  "script": (importstr '../script/init-environment') + |||
    yq delete -i config/environments/${ENVIRONMENT}.yaml '{{ .key }}'
  |||
}
