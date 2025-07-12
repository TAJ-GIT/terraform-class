resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name="tera_vpc"
    }  
}
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    #availability_zone = "us-east-1"
    tags = {
      name="pub-sub-1"
    }
}
resource "aws_subnet" "pvt" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    #availability_zone = "us-east-1"
    tags = {
      name="pvt-sub-1"
    }
}
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      name="ig"
    }
}
resource "aws_route_table" "name" {
    vpc_id = aws_vpc.name.id

    route {
        cidr_block="0.0.0.0/0"
        gateway_id = aws_internet_gateway.name.id
    }
    tags = {
      name="pub-rt"
    }
}
resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.name.id
    route_table_id = aws_route_table.name.id
} 

resource "aws_eip" "example" {
  domain = "vpc"

  tags = {
    Name = "NAT-EIP"
  }
}
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.name.id  # <-- public subnet

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.name]
}
resource "aws_route_table" "pvt" {
    vpc_id = aws_vpc.name.id

    route {
        cidr_block="0.0.0.0/0"
        nat_gateway_id = aws_eip.example.id
    }
    tags = {
      name="pvt-rt"
    }
}

resource "aws_route_table_association" "pvt-rt" {
    subnet_id = aws_subnet.pvt.id
    route_table_id = aws_route_table.pvt.id
} 



resource "aws_security_group" "name" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.name.ipv6_cidr_block #Make sure you have a VPC created

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebSecurityGroup"
  }
}

resource "aws_instance" "name" {
    ami = "ami-05ffe3c48a9991133"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.name.id
    vpc_security_group_ids = [aws_security_group.name.id]
    tags = {
      name="terra-ec2"
    }

}



