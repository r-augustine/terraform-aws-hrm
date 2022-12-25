# Setup  aws provider
provider "aws" {
  region   = var.region
  role_arn = var.role_arn
}
