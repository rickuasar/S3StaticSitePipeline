terraform {
  backend "s3" {
    bucket = "tfstratusgrid"
    key    = "stratus"
    region = "us-east-1"
  }
}