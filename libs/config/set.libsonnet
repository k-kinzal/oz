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
  "steps": [
    {
      "script": (importstr '../script/init-environment') + |||
        cat config/environments/${ENVIRONMENT}.yaml | yq -y ".[\"$(echo '{{ .key }}' | sed -e 's/\./"]["/g')\"]=\"{{ .value }}\"" > config/environments/${ENVIRONMENT}.yaml
      |||
    },
    {
      "task": "config.show"
    }
  ]
}
