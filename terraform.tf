terraform {
  cloud {
    organization = "r-augustine"
  }

  required_providers {
    aws = {
      source  = "hasicorp/aws"
      version = "4.48.0"
    }
  }

  required_version = ">= 1.3.6"
}
