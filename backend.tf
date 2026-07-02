# Backend configuration - update bucket/table names before use.
# See README.md "Setup" section for how to bootstrap these resources.
terraform {
  backend "s3" {
    bucket         = "REPLACE-WITH-YOUR-STATE-BUCKET-NAME"
    key            = "three-tier-aws/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "REPLACE-WITH-YOUR-LOCK-TABLE-NAME"
    encrypt        = true
  }
}
