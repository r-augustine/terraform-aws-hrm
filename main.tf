# Set up CodeCommit Repository
resource "aws_codecommit_repository" "hrm" {
  repository_name = "r-augustine/hrm"
  description     = "Human Resource Management Application"
}

# Create a Service Role
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

# IAM role providing read-only access to CodeCommit
resource "aws_iam_role" "amplify_codecommit" {
  name                = "AmplifyCodeCommit"
  assume_role_policy  = join(data.aws_iam_policy_document.assume_role.*.json)
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"]
}

# Set up Amplify
resource "aws_amplify_app" "hrm_app" {
  name                     = "hrm-app"
  repository               = aws_codecommit_repository.hrm.clone_url_http
  iam_service_role_arn     = aws_iam_role.amplify_codecommit.arn
  enable_branch_auto_build = true
  build_spec               = <<-EOT
    version: 0.1
    frontend:
        phases:
            preBuild:
                commands:
                    -  npm install
            build:
                commands:
                    -  npm run build
        artifacts:
            baseDirectory: build
            files:
                - '**/*'
        cache:
            paths:
                -  node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV = "dev"
  }

}

# Add development branch
resource "aws_amplify_branch" "dev" {
  app_id      = aws_amplify_app.hrm_app.id
  branch_name = "dev"
  framework   = "React"
  stage       = "DEVELOPMENT"
}

# Add main branch
resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.hrm_app.id
  branch_name = "main"
  framework   = "React"
  stage       = "PRODUCTION"
}
