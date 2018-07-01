local utils = import '../utils.libsonnet';
{
  "description": "Create an S3 bucket to deploy AWS Lambda.",
  "options": (import '../awa-options.libsonnet') + [],
  "autoenv": true,
  "steps": [
    {
      "script": |||
        S3_BUCKET_NAME=$(./oz config get s3.bucket-name -o json | head -n 1 | jq -r '.msg')
        if [[ "${S3_BUCKET_NAME}" == "" || "${S3_BUCKET_NAME}" == "null" ]]; then
      ||| + utils.script.err('Bucket not exists') + |||
        fi
      |||
    },
    {
      "script": |||
        AWS_REGION=${AWS_REGION:-$(aws configure get aws_default_region)}
        AWS_REGION=${AWS_REGION:-us-east-1}
        S3_BUCKET_NAME=$(./oz config get s3.bucket-name -o json | head -n 1 | jq -r '.msg')

        aws --region ${AWS_REGION} s3api delete-bucket --bucket ${S3_BUCKET_NAME}
      |||
    },
    {
      "script": |||
        AWS_REGION=${AWS_REGION:-$(aws configure get aws_default_region)}
        AWS_REGION=${AWS_REGION:-us-east-1}
        S3_BUCKET_NAME=$(./oz config get s3.bucket-name -o json | head -n 1 | jq -r '.msg')

        ./oz config delete s3.bucket-name ${S3_BUCKET_NAME} -o json >/dev/null
        if [[ "$?" -ne 0 && "$?" -ne 4 ]]; then
          exit 1;
        fi

        echo "Delete S3 Bucket: ${S3_BUCKET_NAME}"
      |||
    }
  ]
}
