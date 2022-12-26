# Set up CodeCommit Repository
resource "aws_codecommit_repository" "hrm" {
  repository_name = "r-augustine/hrm"
  description     = "Human Resource Management Application"
}
