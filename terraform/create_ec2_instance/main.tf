provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  key_name = "terraform"
  subnet_id = "subnet-019a123456789abc"
}
