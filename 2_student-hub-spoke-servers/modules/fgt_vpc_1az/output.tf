output "subnet_cidrs" {
  value = local.subnet_cidrs
}

output "subnet_ids" {
  value = local.subnet_ids
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "sg_ids" {
  value = {
    mgmt      = aws_security_group.sg-vpc-sec-mgmt.id
    private   = aws_security_group.sg-vpc-sec-private.id
    public    = aws_security_group.sg-vpc-sec-public.id
    bastion   = aws_security_group.sg-vpc-sec-bastion.id
    allow_all = aws_security_group.sg-vpc-sec-allow-all.id
  }
}

output "rt_ids" {
  value = {
    mgmt    = aws_route_table.rt-mgmt-ha.id
    public  = aws_route_table.rt-public.id
    bastion = aws_route_table.rt-bastion.id
  }
}