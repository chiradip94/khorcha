
# Upload JAR to S3
resource "aws_s3_object" "lambda_jar" {
  bucket       = var.lambda_bucket_name
  key          = var.lambda_path_in_s3
  source       = var.lambda_artifact
  content_type = "application/java-archive"
  source_hash = filemd5(var.lambda_artifact)
}

# Lambda Function

resource "aws_lambda_function" "micronaut_lambda" {
  function_name = "kharcha-${var.environment}"
  runtime       = "java17"
  handler       = "io.micronaut.function.aws.proxy.payload1.ApiGatewayProxyRequestEventFunction"
  role          = var.role
  s3_bucket     = var.lambda_bucket_name
  s3_key        = aws_s3_object.lambda_jar.key
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_mem_size

  tags = var.tags
}