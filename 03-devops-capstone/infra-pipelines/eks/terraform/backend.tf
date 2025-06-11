terraform {
  backend "s3" {
    bucket = "capstone-pipelines-tw"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
