resource "aws_s3_bucket" "my_bucket" {
  bucket = "cdp-data-platform-s3-bucket"  # Change to a unique bucket name
  # aws_s3_bucket_acl = "private"

  tags = {
    Name        = "MyBucket"
    Environment = "Dev"
  }
}
