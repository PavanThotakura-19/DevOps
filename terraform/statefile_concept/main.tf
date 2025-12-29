provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "new_s3_bucket"
}

resource "aws_dynamodb_table" "terraform-lock" {
  name = "terraform-lock"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
}
}
