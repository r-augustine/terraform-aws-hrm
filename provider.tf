# Setup  aws provider
provider "aws" {
  region   = "us-east-1"
  role_arn = var.role_arn
}
