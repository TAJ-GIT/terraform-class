terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "qwsdfghjuytfcbju"   #bucket name
    key          = "terraform.tfstate"
    region = "us-east-1"
  }
}
