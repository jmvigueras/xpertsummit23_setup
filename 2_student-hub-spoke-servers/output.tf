output "hub" {
  value = {
    fgt-1_mgmt   = "https://${module.hub.fgt_eip_mgmt}:${local.admin_port}"
    fgt-1_public = module.hub.fgt_eip_public
    username     = "admin"
    fgt-1_pass   = module.hub.fgt_id
    vpn_psk      = module.hub_config.vpn_psk
    admin_cidr   = local.admin_cidr
    api_key      = module.hub_config.api_key
  }
}

output "spoke" {
  value = {
    fgt-1_mgmt   = "https://${module.spoke.fgt_eip_mgmt}:${local.admin_port}"
    fgt-1_public = module.spoke.fgt_eip_public
    username     = "admin"
    fgt-1_pass   = module.spoke.fgt_id
    vpn_psk      = module.spoke_config.vpn_psk
    admin_cidr   = local.admin_cidr
    api_key      = module.spoke_config.api_key
  }
}

output "lab_server" {
  value = {
    private_ip = module.lab_server.vm["private_ip"]
    lab_uri    = "http://${module.lab_server.vm["public_ip"]}/${local.externalid_token}"
    phpadmin   = "http://${module.lab_server.vm["public_ip"]}/${local.random_url_db}"
    db_user    = "root"
    db_pass    = local.db["db_pass"]
  }
}

output "student_server" {
  value = {
    private_ip  = module.student_server.vm["private_ip"]
    public_ip   = module.student_server.vm["public_ip"]
    server_url  = "http://${module.student_server.vm["public_ip"]}"
    fgt_vip_url = "http://${module.spoke.fgt_eip_public}"
    fwb_app_url = "http://${local.student_id}.${data.aws_route53_zone.data_dns_zone.name}"
  }
}

output "lab_portal" {
  value = {
    portal   = "http://${local.lab_fqdn}/${local.externalid_token}"
    phpamdin = "http://${local.lab_fqdn}/${local.random_url_db}"
    db_user  = "root"
    db_pass  = local.db["db_pass"]
  }
}