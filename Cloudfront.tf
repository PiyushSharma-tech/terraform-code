resource "aws_s3_bucket" "testing_bucket" {
    bucket = "bucket-testtera"
}


# cloudfront origin access identity
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "origin access identity"
}

# setting up s3 bucket permission using IAM Policy Document
data "aws_iam_policy_document" "read_bucket" {
  statement {
    actions = [ "s3:GetObject" ]
    resources = [ "${aws_s3_bucket.testing_bucket.arn}/*"]
    principals {
      type = "AWS"
      identifiers = [ aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn ]
    }
  }
  
}

resource "aws_s3_bucket_policy" "allow_bucket" {
  bucket = aws_s3_bucket.testing_bucket.id
  policy = data.aws_iam_policy_document.read_bucket.json
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.testing_bucket.bucket_domain_name
    origin_id   = aws_s3_bucket.testing_bucket.bucket
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  
  enabled = true

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.testing_bucket.bucket
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 300
    max_ttl = 3600

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  price_class = "PriceClass_200"

  tags = {
    resource= "cloudfrontOnS3"
    env= "dev"
    creator= "Using terraform"
  }
}

output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

/* resource "aws_s3_bucket" "b" {
  bucket = "mycdpuniquebucket"

  tags = {
    Name = "My bucket"
  }
}

# Create the S3 bucket for logging
resource "aws_s3_bucket" "logs" {
  bucket = "mycdpuniquebucketlogs"

  tags = {
    Name = "My logs bucket"
  }

  # Remove the object ownership setting
}

# Set the bucket policy to allow CloudFront to write logs
resource "aws_s3_bucket_policy" "logs_policy" {
  bucket = aws_s3_bucket.logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.logs.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

locals {
  s3_origin_id = "myS3Origin"
}

# Corrected CloudFront Origin Access Control resource
resource "aws_cloudfront_origin_access_control" "default" {
  name                         = "MyOriginAccessControl"
  description                  = "Origin Access Control for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior             = "always"
  signing_protocol             = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name                 = aws_s3_bucket.b.bucket_regional_domain_name
    origin_access_control_id    = aws_cloudfront_origin_access_control.default.id
    origin_id                   = local.s3_origin_id
  }

  enabled                     = true
  is_ipv6_enabled             = true
  comment                     = "Some comment"
  default_root_object         = "index.html"

  logging_config {
    include_cookies = false
    bucket         = aws_s3_bucket.logs.bucket_regional_domain_name
    prefix         = "myprefix"
  }

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern      = "/content/immutable/*"
    allowed_methods   = ["GET", "HEAD", "OPTIONS"]
    cached_methods    = ["GET", "HEAD", "OPTIONS"]
    target_origin_id  = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy  = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern      = "/content/*"
    allowed_methods   = ["GET", "HEAD", "OPTIONS"]
    cached_methods    = ["GET", "HEAD"]
    target_origin_id  = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy  = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
} */

/* resource "aws_s3_bucket" "b" {
  bucket = "mycdpuniquebucket"

  tags = {
    Name = "My bucket"
  }
}

# Create the S3 bucket for logging
resource "aws_s3_bucket" "logs" {
  bucket = "mycdpuniquebucketlogs"

  tags = {
    Name = "My logs bucket"
  }

  # Set the ACL to allow full control for the account
  # acl = "private"
}

# Set the bucket policy to allow CloudFront to write logs
resource "aws_s3_bucket_policy" "logs_policy" {
  bucket = aws_s3_bucket.logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.logs.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

locals {
  s3_origin_id = "myS3Origin"
}

# Corrected CloudFront Origin Access Control resource
resource "aws_cloudfront_origin_access_control" "default" {
  name                         = "MyOriginAccessControl"
  description                  = "Origin Access Control for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior             = "always"
  signing_protocol             = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.logs.bucket_regional_domain_name
    prefix          = "myprefix"
  }

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl               = 0
    default_ttl           = 3600
    max_ttl               = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern = "/content/immutable/*"
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl               = 0
    default_ttl           = 86400
    max_ttl               = 31536000
    compress              = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern = "/content/*"
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl               = 0
    default_ttl           = 3600
    max_ttl               = 86400
    compress              = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
*/


/* 
resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-cdp-unique-bucket-name" # Replace with a unique bucket name
  # acl    = "private"
}

resource "aws_cloudfront_origin_access_identity" "my_identity" {
  comment = "Origin Access Identity for my S3 bucket"
}

resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = aws_s3_bucket.my_bucket.bucket_regional_domain_name
    origin_id   = "S3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.my_identity.id
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "S3Origin"
    viewer_protocol_policy  = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none" # Change to "all" or "whitelist" if needed
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" # Change to "whitelist" or "blacklist" if needed
      locations        = []
    }
  }

  tags = {
    Name = "My CloudFront Distribution"
  }
}
*/



/* # S3 Bucket (Origin)
resource "aws_s3_bucket" "example_bucket" {
  bucket = "cdp-new-cloudfront-origin-bucket"
  #acl    = "private"  # Set to private for security
}

# CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "Access Identity for S3 bucket"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "example_distribution" {
  origin {
    domain_name = aws_s3_bucket.example_bucket.bucket_regional_domain_name
    origin_id   = "S3-example-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.example.id
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "S3-example-origin"
    viewer_protocol_policy  = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
} */