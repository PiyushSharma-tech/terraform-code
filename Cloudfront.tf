# S3 Bucket (Origin)
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
}