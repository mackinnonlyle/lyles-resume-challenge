# Declare the provider for AWS
provider "aws" {
  region = "us-east-1"
}

# Declare the S3 bucket resource
resource "aws_s3_bucket" "MyWebsite" {
  bucket = "terraform-lyles-resume-challenge"
  acl    = "public-read"
}

# Declare the S3 bucket website configuration resource
resource "aws_s3_bucket_website" "MyWebsite" {
  bucket = "${aws_s3_bucket.MyWebsite.id}"
  index_document = "index.html"
}

# Declare the S3 bucket policy resource
resource "aws_s3_bucket_policy" "my_website" {
  bucket = aws_s3_bucket.my_website.id

  policy = <<EOF
{
  "Id": "MyPolicy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.my_website.arn}/*"
    }
  ]
}
EOF
}

# Declare the CloudFront distribution resource
resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.my_website.bucket_regional_domain_name}"
    origin_id   = "terraform-lyles-resume-challenge.s3.us-east-1.amazonaws.com"

    custom_origin_config {
      origin_protocol_policy = "match-viewer"
    }
  }

  default_cache_behavior {
    target_origin_id = "terraform-lyles-resume-challenge.s3.us-east-1.amazonaws.com"

    viewer_protocol_policy = "allow-all"
    forwarded_values {
      query_string = false
    }
  }

  enabled = true

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.my_certificate.arn}"
    ssl_support_method  = "sni-only"
  }

  default_root_object = "index.html"

  aliases = ["terraform-challenge.lylemackinnon.com"]
}


# Declare the Route 53 record set group resource
resource "aws_route53_record_set_group" "my_record_set_group" {
  hosted_zone_id = "Z00882183LTKWQTNEVG0Z"

  record_sets {
    name = "terraform-challenge.lylemackinnon.com"
    type = "A"

    alias {
      name                   = "${aws_cloudfront_distribution.my_distribution.domain_name}"
      zone_id                = "${aws_cloudfront_distribution.my_distribution.hosted_zone_id}"
      evaluate_target_health = true
    }
  }
}

# Declare the ACM certificate resource
resource "aws_acm_certificate" "my_certificate" {
  domain_name       = "terraform-challenge.lylemackinnon.com"
  validation_method = "DNS"
}

# Declare the DynamoDB table resource
resource "aws_dynamodb_table" "counter_table" {
  name            = "terraform-lyles-resume-challenge"
  billing_mode    = "PAY_PER_REQUEST"
  read_capacity   = 5
  write_capacity  = 5

  attribute {
    name = "ID"
    type = "S"
  }

  key_schema {
    attribute_name = "ID"
    key_type       = "HASH"
  }
}


# Declare the Lambda function resource
resource "aws_lambda_function" "counter_function" {
  filename      = "counter-app/function/app.zip"
  function_name = "counter_function"
  role          = "${aws_iam_role.counter_function_role.arn}"
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = "${base64sha256(file("counter-app/function/app.zip"))}"
  memory_size   = 128
  timeout       = 3

  environment {
    variables = {
      TABLE_NAME = "terraform-lyles-resume-challenge"
    }
  }
}

# Declare the IAM role for the Lambda function
resource "aws_iam_role" "counter_function_role" {
  name = "counter_function_role"

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

# Declare the IAM policy for the Lambda function
resource "aws_iam_policy" "counter_function_policy" {
  name = "counter_function_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  " Statement": [
    {
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ],
      "Effect": "Allow",
      "Resource": "${aws_dynamodb_table.counter_table.arn}"
    }
  ]
}
EOF
}

# Attach the IAM policy to the IAM role for the Lambda function
resource "aws_iam_policy_attachment" "counter_function_policy_attachment" {
  name       = "counter_function_policy_attachment"
  policy_arn = "${aws_iam_policy.counter_function_policy.arn}"
  role       = "${aws_iam_role.counter_function_role.name}"
}

# Declare the API Gateway REST API resource
resource "aws_api_gateway_rest_api" "counter_api" {
  name = "counter_api"
}

# Declare the API Gateway resource
resource "aws_api_gateway_resource" "counter_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.counter_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.counter_api.root_resource_id}"
  path_part   = "visit"
}

resource "aws_api_gateway_method" "counter_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.counter_api.id}"
  resource_id   = "${aws_api_gateway_resource.counter_resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}
