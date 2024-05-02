# Define provider
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = "a3f1afdf67dbd4d0f8a754745da04c92-1431086496.us-east-1.elb.amazonaws.com"
    origin_id = "LoadBalancerOrigin"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }


  enabled             = true
  is_ipv6_enabled     = true

  default_cache_behavior {
    target_origin_id   = "LoadBalancerOrigin"
    
    allowed_methods    = ["GET", "HEAD", "OPTIONS"]
    cached_methods     = ["GET", "HEAD", "OPTIONS"]
    
    min_ttl            = 0
    default_ttl        = 3600
    max_ttl            = 86400

    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # Additional cache behaviors can be added as needed

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

data "aws_cloudfront_cache_policy" "example" {
  name = "Managed-CachingOptimized"
}