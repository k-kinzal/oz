local utils = import '../utils.libsonnet';
{
  "description": "Planning serverless application model",
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
          OUT=$(aws --region ${AWS_REGION} cloudformation deploy --no-execute-changeset --template-file dist/$(basename ${TEMPLATE_FILE} | cut -d'.' -f1)-output.yaml --stack-name ${STACK_NAME} --capabilities CAPABILITY_IAM)
        else
          OUT=$(aws --region ${AWS_REGION} cloudformation deploy --no-execute-changeset --template-file dist/$(basename ${TEMPLATE_FILE} | cut -d'.' -f1)-output.yaml --stack-name ${STACK_NAME} --capabilities CAPABILITY_IAM --parameter-overrides ${PARAMETERS})
        fi
        STACK_ARN=$(echo $OUT | grep -o 'arn:aws:cloudformation:.*$')
        if [[ "${STACK_ARN}" = "" ]]; then
          exit 0;
        fi

        JSON=$(aws --region ${AWS_REGION} cloudformation describe-change-set --change-set-name ${STACK_ARN});
        CHANGES=$(echo $JSON | jq -r '.Changes[] | .ResourceChange.Action + "-" + .ResourceChange.Replacement + " " + .ResourceChange.LogicalResourceId + " (" + .ResourceChange.PhysicalResourceId + ")"' | sed 's/Modify-False/~/g' | sed 's/Modify-True/-\/+/g' | sed 's/Remove/-/g' | sed 's/Add-/+/g' | sed 's/ ()//g' | sed 's/$/\\n/g' | sed 's/^[[:space:]]*/\\n/g')

        echo "\nSAM will perform the following actions:\n"
        echo "${STACK_NAME}"
        echo $CHANGES;
        echo "Plan: $(echo $CHANGES | grep '^\+' | wc -l) to add, $(echo $CHANGES | grep '^\(\~\|-/\+\)' | wc -l) to change, $(echo $CHANGES | grep '^-' | wc -l) to destroy."
      |||
    },
  ]
}
