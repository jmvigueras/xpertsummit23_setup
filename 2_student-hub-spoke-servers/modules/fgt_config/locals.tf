locals {
  # FGT deafult name
  fgt_id = var.config_spoke ? "${var.spoke["id"]}-1" : var.config_hub ? "${var.hub[0]["id"]}-1" : "${var.prefix}-fgt-${var.suffix}"
  # Generate map of IPs for each subnet
  fgt_ni_ips = {
    for ni in var.fgt_ni_index :
    ni => cidrhost(var.subnet_cidrs[ni], var.fgt_cidrhost)
  }
}
