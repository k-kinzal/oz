local utils = import '../utils.libsonnet';
{
  "description": "Packaging functions",
  "options": utils.options.aws + [],
  "autoenv": true,
  "steps": [
    {
      "script": |||
        STACK_NAME=$(./oz config get stack-name -o json | head -n 1 | jq -r '.msg')
        if [[ "${STACK_NAME}" == "" || "${STACK_NAME}" == "null" ]]; then
      ||| + utils.script.err('Stack has not been created yet') + |||
        fi
      |||
    },
    {
      "script": (importstr '../script/init-awscli') + |||
        STACK_NAME=$(./oz config get stack-name -o json | head -n 1 | jq -r '.msg')
        if ! aws --region ${AWS_REGION} cloudformation describe-stacks --stack-name ${STACK_NAME} 2>&1 >/dev/null; then
      ||| + utils.script.err('Stack has not been created yet') + |||
        fi

        aws --region ${AWS_REGION} cloudformation delete-stack --stack-name ${STACK_NAME}
        aws --region ${AWS_REGION} cloudformation wait stack-delete-complete --stack-name ${STACK_NAME}
      |||
    },
    {
      "script": |||
        STACK_NAME=$(./oz config get stack-name -o json | head -n 1 | jq -r '.msg')

        ./oz config delete stack-name >/dev/null

        echo "Delete Stack: \`${STACK_NAME}\`"
      |||
    }
  ]
}
