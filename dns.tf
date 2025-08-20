resource "ovh_domain_zone_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cf_cert.domain_validation_options : dvo.domain_name => {
      name   = trimsuffix(dvo.resource_record_name, ".tkuresume.pl.")
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }

  zone      = "tkuresume.pl"
  subdomain = each.value.name
  fieldtype = each.value.type
  ttl       = 600
  target    = each.value.value
}

resource "ovh_domain_zone_record" "cloudfront_cname" {
  zone      = "tkuresume.pl"
  subdomain = "cv"
  fieldtype = "CNAME"
  ttl       = 3600
  target    = "${aws_cloudfront_distribution.my_cf.domain_name}."
}