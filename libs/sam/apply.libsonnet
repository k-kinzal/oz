local utils = import '../utils.libsonnet';
{
  "description": "Apply serverless application model",
  "parameters": [
    {
      "name": "template-file",
      "default": "template.yaml",
      "required": true
    }
  ],
  "options": utils.options.aws + [
    {
      "name": "s3.bucket-name",
      "required": true
    },
    {
      "name": "stack-name",
      "default": ""
    }
  ],
  "autoenv": true,
  "steps": [
    {
      "task": "sam.package",
      "arguments": {
        "template-file": '{{ get "template-file" }}',
        "aws.profile": '{{ get "aws.profile" }}',
        "aws.access-key-id": '{{ get "aws.access-key-id" }}',
        "aws.secret-access-key": '{{ get "aws.secret-access-key" }}',
        "aws.region": '{{ get "aws.region" }}',
        "s3.bucket-name": '{{ get "s3.bucket-name" }}'
      }
    },
    {
      "script": (importstr '../script/init-awscli') + |||
        STACK_NAME=$(./oz sam generate-stack-name --stack-name "${STACK_NAME}" -o json | head -n 1 | jq -r '.msg')
        PARAMETERS=$(./oz sam generate-parameter-string -o json | head -n 1 | jq -r '.msg')

        if [[ "$PARAMETERS" = "" ]]; then
          aws --region ${AWS_REGION} cloudformation deploy --template-file dist/$(basename ${TEMPLATE_FILE} | cut -d'.' -f1)-output.yaml --stack-name ${STACK_NAME} --capabilities CAPABILITY_IAM
        else
          aws --region ${AWS_REGION} cloudformation deploy --template-file dist/$(basename ${TEMPLATE_FILE} | cut -d'.' -f1)-output.yaml --stack-name ${STACK_NAME} --capabilities CAPABILITY_IAM --parameter-overrides ${PARAMETERS}
        fi
      |||
    },
  ]
}
