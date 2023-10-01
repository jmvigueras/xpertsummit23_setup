output "hub" {
  value = {
    fgt-1_mgmt   = "https://${module.hub.fgt_eip_mgmt}:${local.admin_port}"
    fgt-1_public = module.hub.fgt_eip_public
    username     = "admin"
    fgt-1_pass   = module.hub.fgt_id
    vpn_psk      = module.hub_config.vpn_psk
    admin_cidr   = "${chomp(data.http.my-public-ip.response_body)}/32"
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
    admin_cidr   = "${chomp(data.http.my-public-ip.response_body)}/32"
    api_key      = module.spoke_config.api_key
  }
}

output "lab_server" {
  value = {
    private_ip     = module.lab_server.vm["private_ip"]
    public_ip      = module.lab_server.vm["public_ip"]
    portal_uri     = "http://${module.lab_server.vm["public_ip"]}"
    lab_uri        = "http://${module.lab_server.vm["public_ip"]}/${local.externalid_token}"
    phpadmin       = "http://${module.lab_server.vm["public_ip"]}/${local.random_url_db}"
    db_pass        = local.db["db_pass"]
    db_docker_name = local.db["db_host"]
  }
}

output "student_server" {
  value = {
    private_ip = module.student_server.vm["private_ip"]
    public_ip  = module.student_server.vm["public_ip"]
    portal_uri = "http://${module.student_server.vm["public_ip"]}"
  }
}