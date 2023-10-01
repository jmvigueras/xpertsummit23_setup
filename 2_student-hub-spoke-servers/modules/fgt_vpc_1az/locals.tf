locals {
  # ----------------------------------------------------------------------------------
  # Necessary variables 
  # ----------------------------------------------------------------------------------
  # Generate subnet map of string from list of subnets
  subnet_cidrs = {
    for idx, subnet in var.subnet_names :
    subnet => cidrsubnet(var.vpc_cidr, ceil(log(length(var.subnet_names), 2)), idx)
  }
  # Generate maps of subnet ids
  subnet_ids = {
    for subnet in var.subnet_names :
    subnet => aws_subnet.subnets[subnet].id
  }
}