#CodePipeline should be configured in such a way to deploy / update the files for the site
resource "aws_codepipeline" "stratusgridwebsite" {
  name     = "stratusgridwebsite"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.stratusgridwebsite.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.repo_owner
        Repo       = var.repo_name
        Branch     = var.branch
        OAuthToken = var.github_token
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        BucketName = aws_s3_bucket.stratusgridwebsite.bucket
        Extract    = "true"
      }
    }
  }
  /*
  stage {
    name = "Invoke"

    action {
      name            = "Invoke"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        BucketName = aws_s3_bucket.stratusgridwebsite.bucket
        Extract    = "true"
      }
    }
  }
  */

}