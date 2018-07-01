local utils = import '../utils.libsonnet';
{
  "description": "Create an S3 bucket to deploy AWS Lambda.",
  "options": (import '../awa-options.libsonnet') + [
    {
      "name": "s3.bucket-name"
    }
  ],
  "autoenv": true,
  "steps": [
    {
      "script": |||
        AWS_REGION=${AWS_REGION:-$(aws configure get aws_default_region)}
        AWS_REGION=${AWS_REGION:-us-east-1}
        S3_BUCKET_NAME=${S3_BUCKET_NAME:-$(./oz config get s3.bucket-name -o json | head -n 1 | jq -r '.msg')}

        if [[ "${S3_BUCKET_NAME}" == "" || "${S3_BUCKET_NAME}" == "null" ]]; then
          exit 0
        fi
        LENGTH=$(aws --region ${AWS_REGION} s3api list-buckets --query "Buckets[?Name==\`${S3_BUCKET_NAME}\`].Name" | jq 'length')
        if [[ "${LENGTH}" -ne 0 ]]; then
      ||| + utils.script.err('Bucket already exists \\`${S3_BUCKET_NAME}\\`') + |||
        fi
      |||
    },
    {
      "script": |||
        AWS_REGION=${AWS_REGION:-$(aws configure get aws_default_region)}
        AWS_REGION=${AWS_REGION:-us-east-1}
        S3_BUCKET_NAME=${S3_BUCKET_NAME:-$(./oz config get s3.bucket-name -o json | head -n 1 | jq -r '.msg')}
        if [[ "${S3_BUCKET_NAME}" = "" || "${S3_BUCKET_NAME}" = "null" ]]; then
          S3_BUCKET_NAME="aws-serverless-application-model-package-${AWS_REGION}-$(date +%s)"
        fi

        ./oz config set s3.bucket-name ${S3_BUCKET_NAME} -o json >/dev/null
        if [[ "$?" -ne 0 && "$?" -ne 4 ]]; then
          exit 1;
        fi
      |||
    },
    {
      "script": |||
        AWS_REGION=${AWS_REGION:-$(aws configure get aws_default_region)}
        AWS_REGION=${AWS_REGION:-us-east-1}
        S3_BUCKET_NAME=$(./oz config get s3.bucket-name -o json | head -n 1 | jq -r '.msg')

        aws --region ${AWS_REGION} s3api create-bucket --bucket ${S3_BUCKET_NAME} >/dev/null

        echo "Create S3 Bucket: ${S3_BUCKET_NAME}"
      |||
    }
  ]
}
