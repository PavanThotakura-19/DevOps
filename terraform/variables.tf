variable "instance_type" {
  description = "instance type"
  type = string
  default = "t3.micro"
}

resource "aws_instance" "example" {
  instance_type = var.instance_type
}

output "ec2_id" {
   description = "ec2_id"
   value = resource.aws_instance.example.id
}
