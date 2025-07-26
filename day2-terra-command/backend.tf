
terraform {
  backend "s3" {
    bucket         = "buckettaaj"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
    
  }
}
