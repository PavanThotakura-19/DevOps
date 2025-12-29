terraform {
backend "s3" {
  bucket = "new_s3_bucket"
  key = "pavan/terraform.tfstate"
  dynamodb_table = "terraform-lock"
  encrypt = true
  region = "us-east-1"
}
}
