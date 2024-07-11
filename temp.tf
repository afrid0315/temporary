terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "<>"
  secret_key = "<>"
}
  
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my-subnet" {
  vpc_id = "aws_vpc.myvpc.id"
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "my-subnet"
  }
}

resource "aws_internet_gateway" "myInternetGW" {
  vpc_id = "aws_vpc.myvpc.id"
  
  tags = {
    Name = "IGw"
  }
}

resource "aws_route_table" "myroute" {
  vpc_id = "aws_vpc.myvpc.id"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myInternetGW.id
  }

  tags = {
    Name = "routetable"
  }
}

resource "aws_route_table_association" "myrouteassocite" {
  subnet_id = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.myroute.id 
}

resource "aws_security_group" "mysg" {
  vpc_id = "aws_vpc.myvpc.id"
  
  ingress = {
    from_port = 22
    to_port = 22
    protocol = tcp
    cidr_block = ["0.0.0.0/0"]
  } 
  
  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = ["0.0.0.0/0"]
  }
  
  tags= {
    Name = "mysecurity"
  } 
}
  
resource "aws-instance" "example" {
  ami = "<>"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.main.id
  security_group = 
  key_name = "mykey.pem"

}



