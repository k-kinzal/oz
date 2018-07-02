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
      "name": "s3.bucket-name",
      "required": true
    }
  ],
  "autoenv": true,
  "steps": [
    {
      "script": (importstr '../script/init-awscli') + |||
        mkdir -p "dist"

        aws --region ${AWS_REGION} cloudformation package \
            --template-file ${TEMPLATE_FILE} \
            --output-template-file dist/$(basename ${TEMPLATE_FILE} | cut -d'.' -f1)-output.yaml \
            --s3-bucket ${S3_BUCKET_NAME} \
              | grep -v "Execute the following command to deploy the packaged template" \
              | grep -v "aws cloudformation deploy"
      |||
    },
  ]
}
