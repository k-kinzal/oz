local utils = import '../utils.libsonnet';
{
  "description": "Destory serverless application model",
  "options": utils.options.aws + [
    {
      "name": "stack-name",
      "required": true
    }
  ],
  "autoenv": true,
  "steps": [
    {
      "script": |||
        if [[ "${STACK_NAME}" == "" || "${STACK_NAME}" == "null" ]]; then
      ||| + utils.script.err('Stack has not been created yet') + |||
        fi
      |||
    },
    {
      "script": (importstr '../script/init-awscli') + |||
        if ! aws --region ${AWS_REGION} cloudformation describe-stacks --stack-name ${STACK_NAME} 2>&1 >/dev/null; then
      ||| + utils.script.err('Stack has not been created yet \\`${STACK_NAME}\\`') + |||
        fi

        aws --region ${AWS_REGION} cloudformation delete-stack --stack-name ${STACK_NAME}
        aws --region ${AWS_REGION} cloudformation wait stack-delete-complete --stack-name ${STACK_NAME}
      |||
    },
    {
      "script": |||
        ./oz config delete stack-name >/dev/null

        echo "Delete Stack: \`${STACK_NAME}\`"
      |||
    }
  ]
}
