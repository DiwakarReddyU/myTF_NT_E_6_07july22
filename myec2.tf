
# variables
variable "myaccess_key"{}
variable "mysecret_key" {}
variable "myregion" {default = "us-west-2"}
variable "myami" {default ="ami-0b152cfd354c4c7a4"}
variable "myinstance_type" {default ="t2.micro"}
variable "mykey_name" {default = "mykey01june22"}

# provider
provider "aws" {
    access_key ="${var.myaccess_key}"
    secret_key = "${var.mysecret_key}"
    region = "${var.myregion}"

}

# resources
resource "aws_instance" "mywebserver" {
ami = "${var.myami}"
instance_type = "${var.myinstance_type}"
key_name = "${var.mykey_name}"
tags = {"Name"= "mywebserver"}

connection {
  type = "ssh"
  user = "ubuntu"
  host = aws_instance.mywebserver.public_ip
  private_key = "${file("mykey01june22.pem")}"
  agent = false
  timeout = "300s"

}

provisioner "remote-exec" {
    inline = [
        "sudo apt-get update",
        "sudo apt-get install nginx -y",
      
    ]
}
  
}
# Outputs 
output "myec2_id" {
value = aws_instance.mywebserver.id
}











