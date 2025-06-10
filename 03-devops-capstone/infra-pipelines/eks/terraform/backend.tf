terraform {
  backend "s3" {
    bucket = "your-s3-bucket-name"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
