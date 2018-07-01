{
  "description": "get parameter for configuration",
  "parameters": [
    {
      "name": "key",
      "required": true
    }
  ],
  "script": (importstr '../script/init-environment') + |||
    cat config/environments/${ENVIRONMENT}.yaml | yq -c -r ".[\"$(echo '{{ .key }}' | sed -e 's/\./"]["/g')\"]"
  |||
}
