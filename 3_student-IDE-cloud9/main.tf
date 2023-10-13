#--------------------------------------------------------------------------------------------
# Create as much Cloud9 enviroments as users
#--------------------------------------------------------------------------------------------
module "cloud9-ide" {
  depends_on = [aws_route_table_association.vpc_cloud9_ra-subnet]
  count      = length(data.aws_iam_users.users.arns)
  source     = "./modules/cloud9-ide"

  tags      = local.tags
  region    = local.region["id"]              // region to deploy Cloud9 enviroments
  subnet_id = aws_subnet.vpc_cloud9_subnet.id // subnet where allocate Cloud9 instances ni
  user_name = tolist(data.aws_iam_users.users.names)[count.index]
  user_arn  = tolist(data.aws_iam_users.users.arns)[count.index]
}

// Achieve all the users allocated in path prefix
data "aws_iam_users" "users" {
  path_prefix = local.user_path_prefix
}

#--------------------------------------------------------------------------------------------
# Create new VPC and subnet for Cloud9 instance machines
#--------------------------------------------------------------------------------------------
// Cloud9 VPC
resource "aws_vpc" "vpc_cloud9" {
  cidr_block           = local.vpc_cloud9_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = local.tags
}

// IGW need for Internet access
resource "aws_internet_gateway" "vpc_cloud9_igw" {
  vpc_id = aws_vpc.vpc_cloud9.id
  tags   = local.tags
}

// Subnet for Cloud9 instances
resource "aws_subnet" "vpc_cloud9_subnet" {
  vpc_id            = aws_vpc.vpc_cloud9.id
  cidr_block        = cidrsubnet(local.vpc_cloud9_cidr, 1, 0)
  availability_zone = local.region["az1"]
  tags              = local.tags
}

// Create route to INET
resource "aws_route_table" "vpc_cloud9_rt-public" {
  vpc_id = aws_vpc.vpc_cloud9.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_cloud9_igw.id
  }
  tags = local.tags
}

// Route table association subnet
resource "aws_route_table_association" "vpc_cloud9_ra-subnet" {
  subnet_id      = aws_subnet.vpc_cloud9_subnet.id
  route_table_id = aws_route_table.vpc_cloud9_rt-public.id
}