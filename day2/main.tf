resource "aws_instance" "name" {
    ami = "ami-05ffe3c48a999113"
    instance_type = "t2.micro"
    tags = {
        name="ec2-1"
    }
  
}