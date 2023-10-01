output "fgt_id" {
  value = aws_instance.fgt.id
}

output "fgt_eip_mgmt" {
  value = aws_eip.fgt_eip_mgmt.public_ip
}

output "fgt_eip_public" {
  value = aws_eip.fgt_eip_public.public_ip
}

output "fgt_ni_ids" {
  value = {
    for idx, ni in var.fgt_ni_index :
    ni => aws_network_interface.fgt_nis[idx].id
  }
}

output "fgt_ni_ips" {
  value = local.fgt_ni_ips
}