terraform {
  backend "s3" {
    bucket = "capstone-pipelines2-tw"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
