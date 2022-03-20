variable "JAR_PATH" {
  type    = string
  default = "../target/function-sample-aws-4.0.0.RELEASE-aws.jar"
}

resource "aws_iam_role" "lambda-execution-role" {
  name = "lambda-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "sampleLambdaFunction" {
  filename      = var.JAR_PATH
  function_name = "Uppercase"
  role          = aws_iam_role.lambda-execution-role.arn
  handler       = "org.springframework.cloud.function.adapter.aws.FunctionInvoker"
  runtime       = "java11"
  timeout       = 30
  source_code_hash = filebase64sha256(var.JAR_PATH)
  memory_size = 1024

}

