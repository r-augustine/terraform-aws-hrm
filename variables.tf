variable "role_arn" {
  type        = string
  description = "AWS account role to assume when create resources"
  nullable    = false
}


variable "region" {
  type        = string
  description = "AWS default region"
  nullable    = false
}
