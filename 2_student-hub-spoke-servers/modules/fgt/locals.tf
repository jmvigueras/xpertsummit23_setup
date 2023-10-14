locals {
  # ----------------------------------------------------------------------------------
  # FGT IP
  # ----------------------------------------------------------------------------------
  # Generate map of IPs for each subnet
  fgt_ni_ips = {
    for ni in var.fgt_ni_index :
    ni => cidrhost(var.subnet_cidrs[ni], var.fgt_cidrhost)
  }
  fgt_ni_ids = {
    for idx, ni in var.fgt_ni_index :
    ni => aws_network_interface.fgt_nis[idx].id
  }
  # Configure bastion route to fortigate
  config_bastion_route = true
  # Fortigate ID
  fgt_id = var.fgt_id != null ? var.fgt_id : "${var.prefix}-fgt-${var.suffix}"
}