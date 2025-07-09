output "public_ip" {

    value = aws_instance.web.public_ip
  
}
output "private_ip" {
    value = aws_instance.web.private_ip
  
}

### WE NEED "terraform appl" AND THEN RUN "terraform output"