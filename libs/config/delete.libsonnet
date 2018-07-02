{
  "description": "get parameter for configuration",
  "parameters": [
    {
      "name": "key",
      "required": true
    }
  ],
  "steps": [
    {
      "script": (importstr '../script/init-environment') + |||
        cat config/environments/${ENVIRONMENT}.yaml | yq -y "del(.[\"$(echo '{{ .key }}' | sed -e 's/\./"]["/g')\"])" > config/environments/${ENVIRONMENT}.yaml
      |||
    },
    {
      "task": "config.show"
    }
  ]
}
