terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "qwsdfghjuytfcbju"
    key          = "terraform.tfstate"
    region = "us-east-1"
  }
}