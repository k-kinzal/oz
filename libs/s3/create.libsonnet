local utils = import '../utils.libsonnet';
{
  "description": "Create an S3 bucket to deploy AWS Lambda.",
  "options": utils.options.aws + [
    {
      "name": "s3.bucket-name"
    }
  ],
  "autoenv": true,
  "steps": [
    {
      "script": (importstr '../script/init-awscli') + |||
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
      "script": (importstr '../script/init-awscli') + |||
        if [[ "${S3_BUCKET_NAME}" = "" || "${S3_BUCKET_NAME}" = "null" ]]; then
          S3_BUCKET_NAME="serverless-application-model-${AWS_REGION}-$(date +%s)"
        fi

        ./oz config set s3.bucket-name ${S3_BUCKET_NAME} -o json >/dev/null
      |||
    },
    {
      "script": (importstr '../script/init-awscli') + |||
        S3_BUCKET_NAME=$(./oz config get s3.bucket-name -o json | head -n 1 | jq -r '.msg')

        aws --region ${AWS_REGION} s3api create-bucket --bucket ${S3_BUCKET_NAME} --create-bucket-configuration LocationConstraint=${AWS_REGION} >/dev/null
        if [[ "$?" -ne 0 ]]; then
          exit 1;
        fi

        echo "Create S3 Bucket: ${S3_BUCKET_NAME}"
      |||
    }
  ]
}
