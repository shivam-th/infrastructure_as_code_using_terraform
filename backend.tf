terraform {
  backend "s3" {
    bucket         = "demo2332123"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
    workspace_key_prefix = "env"
  }
}