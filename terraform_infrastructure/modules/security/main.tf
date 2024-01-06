#Data block to obtain my ip address from the URI specifieed in the program list usinf curl command
data "external" "myipaddr"{
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}
data "external" "myipaddrv6"{
  program = ["bash", "-c", "curl -s 'https://api64.ipify.org?format=json'"]
}
#Security group for inbound traffic being associated with the VPC
resource "aws_security_group" "ingress_ctrl"{
  name = "inbound-sg"
  description = "for inbound data packets/traffic"
  vpc_id = var.vpc_id
}


#Ingress security group rule for ip version 4 traffic from the internet
resource "aws_vpc_security_group_ingress_rule" "http_ipv4" {
    security_group_id = aws_security_group.ingress_ctrl.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

#Ingress security group rule for ip version 6 traffic from the internet
resource "aws_vpc_security_group_ingress_rule" "http_ipv6" {

  security_group_id = aws_security_group.ingress_ctrl.id
  cidr_ipv6   = "::/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

}

#Ingress security group rule for ip version 4 traffic to traverse port 3000 (for lighting microservice)
resource "aws_vpc_security_group_ingress_rule" "app_port1_ipv4" {
  security_group_id = aws_security_group.ingress_ctrl.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000
}

resource "aws_vpc_security_group_ingress_rule" "app_port2_ipv6" {
  security_group_id = aws_security_group.ingress_ctrl.id
  cidr_ipv6   = "::/0"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000
}

#Ingress security group rule for ip version 4 traffic to traverse port 3000 (for lighting microservice)
resource "aws_vpc_security_group_ingress_rule" "app_port3_ipv4" {
  security_group_id = aws_security_group.ingress_ctrl.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8080
  ip_protocol = "tcp"
  to_port     = 8080
}

resource "aws_vpc_security_group_ingress_rule" "app_port4_ipv6" {
  security_group_id = aws_security_group.ingress_ctrl.id
  cidr_ipv6   = "::/0"
  from_port   = 8080
  ip_protocol = "tcp"
  to_port     = 8080
}

#inbound security group rule to allow entry to EC2 instances (microservices) via SSH using IP address (dynamically obtained)
resource aws_vpc_security_group_ingress_rule "inboundssh"{
  security_group_id = aws_security_group.ingress_ctrl.id
  cidr_ipv4 =  "${chomp(data.external.myipaddr.result.ip)}/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

#Ingress security group rule for HTTPs (secure) ip version 4 traffic
resource aws_vpc_security_group_ingress_rule "https_ipv4"{
  security_group_id = aws_security_group.ingress_ctrl.id
  cidr_ipv4 =  "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

#Ingress security group rule for HTTPs (secure) ip version 6 traffic
resource aws_vpc_security_group_ingress_rule "https_ipv6"{
  security_group_id = aws_security_group.ingress_ctrl.id
  cidr_ipv6 =  "::/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

#Egress security group for data packets routed to the internet gateway
resource "aws_security_group" "egress_ctrl"{
  name = "outbound-sg"
  description = "for outbound subnet data packets/traffic"
  vpc_id = var.vpc_id
}

#Egress security group rule for ip version 6 traffic
resource "aws_vpc_security_group_egress_rule" "outbound_ipv6" {
  security_group_id = aws_security_group.egress_ctrl.id
  cidr_ipv6   = "::/0"
  ip_protocol = "-1"
}

#Egress security group rule for ip version 4 traffic
resource "aws_vpc_security_group_egress_rule" "outbound_ipv4" {
  security_group_id = aws_security_group.egress_ctrl.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "rds-security-group" {
 name        = "Allow postgres"
 description = "Allow inbound traffic from my IP address"
 vpc_id      = var.vpc_id

ingress {
   description = "postgresql ingress route 1"
   from_port   = 5432
   to_port     = 5432
   protocol    = "tcp"
   cidr_blocks = ["${chomp(data.external.myipaddr.result.ip)}/32"]
#    ipv6_cidr_blocks = ["${chomp(data.external.myipaddrv6.result.ip)}/128"]
 }

  ingress {
   description = "postgresql ingress route 2"
   from_port   = 5433
   to_port     = 5433
   protocol    = "tcp"
   cidr_blocks = ["${chomp(data.external.myipaddr.result.ip)}/32"]
 }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]

 }

 tags = {
    Name = "postgres-sg"
 }

}
