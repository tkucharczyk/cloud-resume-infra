
resource "aws_s3_bucket" "cloud-resume" {
  bucket = "tkucloudresume"
}

resource "aws_s3_bucket_ownership_controls" "cloud-resume" {
  bucket = aws_s3_bucket.cloud-resume.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "cloud-resume" {
  bucket = aws_s3_bucket.cloud-resume.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "cloud_-esume" {
  bucket                  = aws_s3_bucket.cloud-resume.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cloud-resume" {
  bucket = aws_s3_bucket.cloud-resume.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.cloud-resume.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.my_cf.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_object" "static-files" {
  for_each = {
    "index.html" = "text/html"
    "fonts.css"  = "text/css"
    "resume.css" = "text/css"
  }

  bucket       = aws_s3_bucket.cloud-resume.id
  key          = each.key
  source       = "${path.module}/site/${each.key}"
  content_type = each.value
  etag         = filemd5("${path.module}/site/${each.key}")
}