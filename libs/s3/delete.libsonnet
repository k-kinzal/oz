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
      ||| + utils.script.err('Bucket not exists') + |||
        fi
        
        LENGTH=$(aws --region ${AWS_REGION} s3api list-buckets --query "Buckets[?Name==\`${S3_BUCKET_NAME}\`].Name" | jq 'length')
        if [[ "${LENGTH}" -eq 0 ]]; then
      ||| + utils.script.err('Bucket not exists') + |||
        fi
      |||
    },
    {
      "script": (importstr '../script/init-awscli') + |||
        aws --region ${AWS_REGION} s3api delete-bucket --bucket ${S3_BUCKET_NAME}
      |||
    },
    {
      "script": |||
        ./oz config delete s3.bucket-name ${S3_BUCKET_NAME} >/dev/null

        echo "Delete S3 Bucket: ${S3_BUCKET_NAME}"
      |||
    }
  ]
}
