output "vpc_id"{
    value = aws_vpc.projectVPC.id
    description = "Id of the vpc"
}
output "public-subnets-cidr-ids"{
    value = [for pubsubnet in aws_subnet.public-subnets[*] : pubsubnet.id ]
    description = "list of public subnet ids"
}

output "private-subnets-cidr-ids" {
  value = [for privsubnet in aws_subnet.private-subnets[*] : privsubnet.id ]
  description = "list of private subnet ids"

}