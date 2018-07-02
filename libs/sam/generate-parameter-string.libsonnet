local utils = import '../utils.libsonnet';
{
  "description": "Generating parameter string of SAM",
  "options": [],
  "autoenv": true,
  "script": |||
    PARAMETERS=$(./oz config get parameters -o json | head -n 1 | jq -r '.msg')
    if [[ "${PARAMETERS}" = "" || "${PARAMETERS}" = "null" ]]; then
      echo ""
      exit 0
    fi

    echo "${PARAMETERS}" | jq -r '.[] | [keys[], values[]] | join("=")'
  |||
}
