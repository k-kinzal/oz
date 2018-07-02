{
  "description": "Managing the Serverless Application",
  "tasks": {
    "generate-stack-name": import 'sam/generate-stack-name.libsonnet',
    "generate-parameter-string": import 'sam/generate-parameter-string.libsonnet',
    "package": import 'sam/package.libsonnet',
    "plan": import 'sam/plan.libsonnet',
    "apply": import 'sam/apply.libsonnet',
    "destroy": import 'sam/destroy.libsonnet',
  }
}
