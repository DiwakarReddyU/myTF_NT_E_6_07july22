
# variables
  variable "myaccess_key" {}
  variable "mysecret_key" {}
  variable "myregion" {default ="us-west-2"}

# provider
provider "aws" {
  access_key = "${var.myaccess_key}"
  secret_key = "${var.mysecret_key}"
  region = "${var.myregion}"
}

# resources
 resource "aws_vpc" "myvpc" {
   cidr_block = "192.168.0.0/16"
   tags = {
     "name" = "myvpc"
   }

 } 

 resource "aws_subnet" "mypublicsubnet" {
   cidr_block = "192.168.1.0/24"
   vpc_id = aws_vpc.myvpc.id
   tags = {
     "name" = "mypublicsubnet"
   }
 }

 resource "aws_route_table" "mypublicroutetable" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      "name" = "mypublicroutetable"
    }
   
 }

 resource "aws_route_table_association" "mypublicrouteassociation" {
subnet_id = aws_subnet.mypublicsubnet.id
     route_table_id = aws_route_table.mypublicroutetable.id

 }

resource "aws_egress_only_internet_gateway" "myigw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      "name" = "myigw"
    }
}

resource "aws_route" "mypublicroute" {
route_table_id = aws_route_table.mypublicroutetable.id
destination_ipv6_cidr_block = "::/0"
egress_only_gateway_id = aws_egress_only_internet_gateway.myigw.id
}

resource "aws_instance" "myinsatnce" {
    ami = "ami-0b152cfd354c4c7a4"
    instance_type= "t2.micro"
    key_name = "mykey01june22"
    subnet_id = aws_subnet.mypublicsubnet.id
tags = {
  "name" = "myinstance"
}
}

# outputs
output "myvpcID" {value = aws_vpc.myvpc.id}
output "mysubnetID" {value = aws_subnet.mypublicsubnet.id}
output "mypublicroutetableID" {value = aws_route.mypublicroute.id}
output "myigwID" {value = aws_egress_only_internet_gateway.myigw.id}
output "myistanceID" {value = aws_instance.myinsatnce.id}





