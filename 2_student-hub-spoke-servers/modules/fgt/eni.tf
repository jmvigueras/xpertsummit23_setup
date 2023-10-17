# ------------------------------------------------------------------
# Create all the eni interfaces FGT active
# ------------------------------------------------------------------
# Create NI using fgt_ni_index
resource "aws_network_interface" "fgt_nis" {
  count             = length(var.fgt_ni_index)
  subnet_id         = var.subnet_ids[var.fgt_ni_index[count.index]]
  security_groups   = [var.sg_ids[var.fgt_ni_index[count.index]]]
  private_ips       = [local.fgt_ni_ips[var.fgt_ni_index[count.index]]]
  source_dest_check = false

  tags = {
    Name = "${var.prefix}-ni-${var.fgt_ni_index[count.index]}-${var.suffix}"
  }
}
# Attach rest of interfaces (index 0 already attahced)
resource "aws_network_interface_attachment" "fgt_nis" {
  count                = length(var.fgt_ni_index) - 1
  instance_id          = aws_instance.fgt.id
  network_interface_id = aws_network_interface.fgt_nis[count.index + 1].id
  device_index         = count.index + 1
}
# Create EIP active public NI
resource "aws_eip" "fgt_eip_public" {
  domain            = "vpc"
  network_interface = local.fgt_ni_ids["public"]
  tags = {
    Name = "${var.prefix}-fgt-${var.suffix}-public-eip"
  }
}
# Create EIP active MGTM NI
resource "aws_eip" "fgt_eip_mgmt" {
  domain            = "vpc"
  network_interface = local.fgt_ni_ids["mgmt"]
  tags = {
    Name = "${var.prefix}-fgt-${var.suffix}-mgmt-eip"
  }
}