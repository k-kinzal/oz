local utils = import '../utils.libsonnet';
{
  "description": "Generating stack name & Save config",
  "options": [
    {
      "name": "stack-name",
      "default": "",
    }
  ],
  "autoenv": true,
  "script": |||
    STACK_NAME=${STACK_NAME:-$(./oz config get stack-name -o json | head -n 1 | jq -r '.msg')}
    if [[ "${STACK_NAME}" = "" || "${STACK_NAME}" = "null" ]]; then
      STACK_NAME=$(openssl rand -hex 10 | egrep -o '[a-z]' | head -n 1)$(date +%s | openssl sha | cut -c 1-11)
    fi

    ./oz config set stack-name ${STACK_NAME} -o json >/dev/null

    echo "${STACK_NAME}"
  |||
}
