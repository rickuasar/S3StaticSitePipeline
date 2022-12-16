#Define my s3bucket
resource "aws_s3_bucket" "stratusgridwebsite"{
  bucket = "stratusgridwebsite"
  acl    = "public-read"
  versioning {
    enabled = false
  }

  tags = {
    Environment = "qa"
    Name        = "stratusgridwebsite"
  }
}
#S3 should be configured as a static site and used to host the content.
resource "aws_s3_bucket_website_configuration" "stratusgridwebsite" {
  bucket = aws_s3_bucket.stratusgridwebsite.bucket
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.stratusgridwebsite.arn}/*","${aws_s3_bucket.stratusgridwebsite.arn}"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "stratusgridwebsite" {
  bucket = aws_s3_bucket.stratusgridwebsite.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "stratusgridwebsite" {
  bucket = aws_s3_bucket.stratusgridwebsite.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}