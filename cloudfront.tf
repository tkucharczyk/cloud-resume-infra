resource "aws_cloudfront_distribution" "my_cf" {
    
  enabled = true
  aliases = ["cv.tkuresume.pl",
             "tkuresume.pl"]
  is_ipv6_enabled = true

  origin {
	domain_name = "tkucloudresume.s3-website.eu-central-1.amazonaws.com"
	origin_id   = "tkucloudresume.s3-website.eu-central-1.amazonaws.com"
    connection_attempts = 3
    connection_timeout = 10

    custom_origin_config {
        http_port = 80
        https_port = 443
        origin_keepalive_timeout = 5
        origin_read_timeout = 30
        origin_protocol_policy = "http-only"
        origin_ssl_protocols = ["SSLv3","TLSv1","TLSv1.1","TLSv1.2",]
    }
  }

  default_cache_behavior {
  cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  compress = true
  target_origin_id = "tkucloudresume.s3-website.eu-central-1.amazonaws.com"
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods = ["GET", "HEAD"]
  cached_methods  = ["GET", "HEAD"]
  }

  restrictions {
	geo_restriction {
	  restriction_type = "none"
	}
  }

  viewer_certificate {
	cloudfront_default_certificate = false
    acm_certificate_arn = "arn:aws:acm:us-east-1:381492029034:certificate/2ac59920-b18f-4722-994a-d0cb0d0a4c17"
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}