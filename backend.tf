terraform {

  backend "s3" {
    bucket         = "tkuresume-tfstate-bucket"
    key            = "global/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}

