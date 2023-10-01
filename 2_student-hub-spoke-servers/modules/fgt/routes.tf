# Add routes to RT Bastion if it exists
resource "aws_route" "r-rt-bastion-1" {
  count                  = local.config_bastion_route ? 1 : 0
  route_table_id         = var.rt_ids["bastion"]
  destination_cidr_block = "172.16.0.0/12"
  network_interface_id   = local.fgt_ni_ids["private"]
}
resource "aws_route" "r-rt-bastion-2" {
  count                  = local.config_bastion_route ? 1 : 0
  route_table_id         = var.rt_ids["bastion"]
  destination_cidr_block = "192.168.0.0/16"
  network_interface_id   = local.fgt_ni_ids["private"]
}
resource "aws_route" "r-rt-bastion-3" {
  count                  = local.config_bastion_route ? 1 : 0
  route_table_id         = var.rt_ids["bastion"]
  destination_cidr_block = "10.0.0.0/8"
  network_interface_id   = local.fgt_ni_ids["private"]
}
