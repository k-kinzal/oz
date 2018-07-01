local utils = import '../utils.libsonnet';
{
  "description": "Packaging functions",
  "parameters": [
    {
      "name": "template-file",
      "default": "template.yaml",
      "required": true
    }
  ],
  "options": utils.options.aws + [
    {
      "name": "s3.bucket-name"
    },
    {
      "name": "stack-name"
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
      "script": |||
        if [[ "${STACK_NAME}" = "" ]]; then
          STACK_NAME=$(date +%s | openssl sha | cut -c 1-12)
        fi

        ./oz config set stack-name ${STACK_NAME} -o json >/dev/null
      |||
    },
    {
      "script": (importstr '../script/init-awscli') + |||
        STACK_NAME=$(./oz config get stack-name -o json | head -n 1 | jq -r '.msg')
        PARAMETERS=$(./oz config get parameters -o json | head -n 1 | jq -r '.msg' | jq -r '.[] | [keys[], values[]] | join("=")')

        aws --region ${AWS_REGION} cloudformation deploy --template-file dist/$(basename ${TEMPLATE_FILE} | cut -d'.' -f1)-output.yaml --stack-name ${STACK_NAME} --capabilities CAPABILITY_IAM --parameter-overrides ${PARAMETERS}
      |||
    },
  ]
}
