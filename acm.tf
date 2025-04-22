resource "aws_acm_certificate" "cf_cert" {
  provider          = aws.virginia
  domain_name       = "tkuresume.pl"
  validation_method = "DNS"

  subject_alternative_names = ["cv.tkuresume.pl"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cf_cert_validation" {
  provider                = aws.virginia
  certificate_arn         = aws_acm_certificate.cf_cert.arn
  validation_record_fqdns = [for record in ovh_domain_zone_record.cert_validation : "${record.subdomain}.tkuresume.pl"]
}