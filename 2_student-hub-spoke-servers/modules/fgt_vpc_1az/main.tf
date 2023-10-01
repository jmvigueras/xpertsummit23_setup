#------------------------------------------------------------------------------------------------------------
# Create VPC SEC and Subnets
#------------------------------------------------------------------------------------------------------------
# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-vpc-sec"
  }
}
# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}
# Subnets
resource "aws_subnet" "subnets" {
  for_each          = local.subnet_cidrs
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.subnet_cidrs[each.key]
  availability_zone = var.region[var.region_az]
  tags = {
    Name = "${var.prefix}-subnet-${each.key}"
  }
}