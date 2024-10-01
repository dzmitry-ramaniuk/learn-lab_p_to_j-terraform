output "lab_vpc_private_subnet_id" {
  value = aws_subnet.private-lab-subnet.id
}

output "lab_vpc_security_group_id" {
  value = aws_security_group.lab-vpc-lambda-sg.id
}