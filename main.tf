terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 1.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}