resource "aws_amplify_app" "hrm-app" {
  name       = "HRM Application"
  repository = aws_codecommit_repository.hrm.clone_url_http
  iam_service_role_arn = aws_iam_role.amplify-codecommit.arn
  enable_branch_auto_build = true
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - npm install
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
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

resource "aws_amplify_branch" "dev" {
  app_id      = aws_amplify_app.hrm-app.id
  branch_name = "dev"
  framework = "React"
  stage     = "DEVELOPMENT"
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.hrm-app.id
  branch_name = "main"
  framework = "React"
  stage     = "PRODUCTION"
}
