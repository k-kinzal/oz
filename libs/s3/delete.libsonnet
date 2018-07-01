local utils = import '../utils.libsonnet';
{
  "description": "Create an S3 bucket to deploy AWS Lambda.",
  "options": utils.options.aws + [],
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
      "script": (importstr '../script/init-awscli') + |||
        S3_BUCKET_NAME=$(./oz config get s3.bucket-name -o json | head -n 1 | jq -r '.msg')

        aws --region ${AWS_REGION} s3api delete-bucket --bucket ${S3_BUCKET_NAME}
      |||
    },
    {
      "script": |||
        S3_BUCKET_NAME=$(./oz config get s3.bucket-name -o json | head -n 1 | jq -r '.msg')

        ./oz config delete s3.bucket-name ${S3_BUCKET_NAME} -o json >/dev/null

        echo "Delete S3 Bucket: ${S3_BUCKET_NAME}"
      |||
    }
  ]
}
