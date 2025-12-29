resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "sub1" {
  cidr_block = "10.0.0.0/28"
  vpc_id = aws_vpc.myvpc.id
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  cidr_block = "10.0.1.0/28"
  vpc_id = aws_vpc.myvpc.id
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}
 
resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}
}

resource "aws_route_table_association" "rt1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.myroute.id
}

resource "aws_route_table_association" "rt2" {
  subnet_id = aws_subnet.sub2.id
  route_table_id = aws_route_table.myroute.id
}

resource "aws_security_group" "websg" {
  name = "web"
  vpc_id = aws_vpc.myvpc.id
  
  ingress {
    description = "ssh port"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
   ingress {
     description = "http port"
     from_port = 80
     to_port = 80
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
}
   egress {
     description = "outbound traffic"
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
}
   tags = {
     Name = "web-sg"
}
}

resource "aws_instance" "in1" {
  ami = 'ami-0261755bbcb8c4a84'
  instance_type = "t3.micro"
  key_name = "key"
  subnet_id = aws_subnet.sub1.id
  vpc_security_group_ids = [aws_security_group.websg.id]
  user_data = base64encode(file("userdata.sh"))
}

resource "aws_instance" "in2" {
  ami = 'ami-0261755bbcb8c4a8'
  instance_type = "t3.micro"
  key_name = "key"
  subnet_id = aws_subnet.sub2.id
  vpc_security_group_ids = [aws_security_group.websg.id]
  user_data = base64encode(file("userdata_1.sh"))
}

resource "aws_lb" "mylb" {
  name = "mylb"
  internal = false
  load_balancer_type = "application"
  subnet_ids = [aws_subnet.sub1.id, aws_subnet.sub2.id]
  security_groups = [aws_security_group.websg.id]
}

resource "aws_lb_target_group" "mytg" {
  name = "myTG"
  port = "80"
  protocol = "HTTP"
  vpc_id = aws_vpc.myvpc.id
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb.mylb.arn
  target_id = aws_instance.in1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb.mylb.arn
  target_id = aws_instance.in2.id
  port = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.mylb.arn
  protocol = "HTTP"
  port = 80
  default_action {
    target_group_arn = aws_lb_target_group.mytg.arn
    type = "forward"
  }
}

