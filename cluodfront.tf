locals {
  s3_origin_id = "myS3Origin-2"
}

resource "aws_cloudfront_origin_access_control" "default_access_sanujan_2" {
  name                              = "default_access_sanujan_2"
  description                       = "default_access_sanujan Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}



resource "aws_cloudfront_distribution" "s3_distribution_sanujan_2" {
  origin {
    domain_name              = aws_s3_bucket.buc2.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default_access_sanujan_2.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

   ordered_cache_behavior {
    path_pattern     = "/index.html"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

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
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_cache_policy" "default_cache_policy" {
  name    = "default-cache-policy"
  min_ttl = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}

output "domain_name" {
  value = aws_cloudfront_distribution.s3_distribution_sanujan_2.domain_name
}
