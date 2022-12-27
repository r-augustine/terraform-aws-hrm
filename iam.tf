#Policy document specifying what service can assume the role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}

# #IAM role providing read-only access to CodeCommit
resource "aws_iam_role" "amplify-codecommit" {
  name                = "AmplifyCodeCommit"
  assume_role_policy  = join("", data.aws_iam_policy_document.assume_role.*.json)
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"]
}
