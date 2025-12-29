required_providers {
  aws = {
    source = "/hashicorp/aws"
    version = "~> 3.79"
}
  azurerm = {
    source = "/hashicorp/azurerm"
    version = ">=2.0, <3.0"
}
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  subscription_id = "subscription-id"
  client_id = "client-id"
  client_secret = "client-secret"
  tenant_id = "tenant-id"
}

provider "aws" {
  alias = "east"
  region = "us-east-1"
}

provider "aws" {
  alias = "west"
  region = "us-west-1"
}

resource "aws_instance" "example" {
  ami = "1234"
  provider = "west"
  subnet_id = "swe1234"
  instance_type = "t3.micro"
  key_name = "ec2_key"
}
