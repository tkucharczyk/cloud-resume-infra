terraform {

  backend "s3" {
    bucket         = "tkuresume-tfstate-bucket" 
    key            = "global/terraform.tfstate"
    region         = "eu-central-1"               
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "tkuresume-tfstate-bucket" 

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "infra"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Locks"
    Environment = "infra"
  }
}
