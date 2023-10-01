# Route mgmt
resource "aws_route_table" "rt-mgmt-ha" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-rt-mgmt-ha"
  }
}
# Route public
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-rt-public"
  }
}
# Route private
resource "aws_route_table" "rt-bastion" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-rt-bastion"
  }
}
# Route tables associations
resource "aws_route_table_association" "ra-subnet-mgmt-ha" {
  subnet_id      = aws_subnet.subnets["mgmt"].id
  route_table_id = aws_route_table.rt-mgmt-ha.id
}
resource "aws_route_table_association" "ra-subnet-public" {
  subnet_id      = aws_subnet.subnets["public"].id
  route_table_id = aws_route_table.rt-public.id
}
resource "aws_route_table_association" "ra-subnet-bastion" {
  subnet_id      = aws_subnet.subnets["bastion"].id
  route_table_id = aws_route_table.rt-bastion.id
}