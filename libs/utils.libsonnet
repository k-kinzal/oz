{
  "options": {
    "aws": [
      {
        "name": "aws.profile",
        "default": "default"
      },
      {
        "name": "aws.access-key-id"
      },
      {
        "name": "aws.secret-access-key"
      },
      {
        "name": "aws.region"
      }
    ]
  },
  "script": {
    err(msg):: 'echo "\\033[0;33mError: ' + msg + '\\033[0;39m" 1>&2; exit 1;',
    warn(msg):: 'echo "\\033[0;33mError: ' + msg + '\\033[0;39m" 1>&2;',
  }
}
