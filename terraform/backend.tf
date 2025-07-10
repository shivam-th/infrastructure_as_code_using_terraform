terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-212"
    key            = "web-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}