terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
    # ❌ remove this line:
    # use_lockfile = false
  }
}
