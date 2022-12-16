locals {
  s3_origin_id = "s3-my-webapp.stratusgridwebsite.com"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "s3-my-webapp.stratusgridwebsite.com"
}

resource "aws_cloudfront_distribution" "stratusgridwebsite" {
  #Amazon CloudFront should be configured to distribute the content from the S3 static site.  
  origin {
    domain_name = aws_s3_bucket.stratusgridwebsite.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "stratusgridwebsite"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "bg.jpg"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }
  #Amazon CloudFront should have an additional behavior configured to cache an image for a default / minimum / maximum TTL = 30 minutes
    min_ttl                = 1800
    default_ttl            = 1800
    max_ttl                = 1800
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US","CO"]
    }
  }

  tags = {
    Environment = "qa"
    Name        = "stratusgridwebsite"
  }
 #Amazon CloudFront should have SSL enabled using the Default CloudFront Certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}