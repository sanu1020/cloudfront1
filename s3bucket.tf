resource "aws_s3_bucket" "buc2" {
  bucket = "terraform-cloudfront-sanujan-2"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_acl" "terraform-cloudfront-sanujan-acl-2" {
  bucket = aws_s3_bucket.buc2.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "example-2" {
  bucket = aws_s3_bucket.buc2.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "example-2" {
  bucket = aws_s3_bucket.buc2.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "allow_access_to_cloudfront-2" {
  bucket = aws_s3_bucket.buc2.id
    
  policy = <<EOT
{
 "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "S3::GetObject",
            "Action": [
                "*"
            ],
            "Resource": [
                "arn:aws:s3:::terraform-cloudfront-sanujan-2/*"
            ]
        }
    ]
}
EOT
}


resource "aws_s3_bucket_website_configuration" "static-website-hosting-2" {
  bucket = aws_s3_bucket.buc2.bucket
  
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "object-2" {
  bucket = aws_s3_bucket.buc2.id
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}