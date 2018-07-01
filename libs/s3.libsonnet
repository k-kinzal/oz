{
  "description": "Managing the S3 bucket for deploying AWS Lambda",
  "tasks": {
    "create": import 's3/create.libsonnet',
    "delete": import 's3/delete.libsonnet',
  }
}
