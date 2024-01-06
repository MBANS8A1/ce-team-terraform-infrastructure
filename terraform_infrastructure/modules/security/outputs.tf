output "security_group_ids" {
value =[aws_security_group.rds-security-group.id]
}

output "egresscontrol_vpc_id"{
    value = aws_security_group.egress_ctrl.vpc_id
}
output "ingresscontrol_vpc_id"{
    value = aws_security_group.ingress_ctrl.vpc_id
}