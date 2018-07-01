std.manifestYamlDoc({
  "tasks": {
    "init": import 'libs/init.libsonnet',
    "config": import 'libs/config.libsonnet',
    "s3": import 'libs/s3.libsonnet',
  }
})
