terraform {
  backend "s3" {
    bucket = "capstone-pipelines2-tw"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
