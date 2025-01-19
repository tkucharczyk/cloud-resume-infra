resource "aws_s3_bucket" "cloud-resume" {
  bucket = "tkucloudresume" 
}

resource "aws_s3_bucket_policy" "cloud-resume-policy" {
  bucket = aws_s3_bucket.cloud-resume.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::tkucloudresume/*"
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.cloud-resume.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_hosting" {
  bucket = aws_s3_bucket.cloud-resume.id

  index_document {
    suffix = "index.html" 
  }

  error_document {
    key = "error.html" 
  }
}