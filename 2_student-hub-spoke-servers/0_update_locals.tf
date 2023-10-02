locals {
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  # Provide a common tag prefix value that will be used in the name tag for all resources
  prefix = "xs23"
  # Region to deploy FGT
  region = {
    id  = "eu-central-1"
    az1 = "eu-central-1a"
    az2 = "eu-central-1b" // same AZ id as AZ1 for a single AZ deployment
  }
  # Tags
  tags = {
    Project = "xpertsummit23"
  }
  #-----------------------------------------------------------------------------------------------------
  # FGT General
  #-----------------------------------------------------------------------------------------------------
  admin_port = "8443"
  admin_cidr = "0.0.0.0/0"

  fgt_instance_type = "c6i.large"
  fgt_build         = "build1517"
  license_type      = "payg"
  #-----------------------------------------------------------------------------------------------------
  # HUB
  #-----------------------------------------------------------------------------------------------------
  hub_vpc_cidr = "10.10.10.0/24"

  hub = [{
    id                = "HUB"
    bgp_asn_hub       = "65000"
    bgp_asn_spoke     = "65000"
    vpn_cidr          = "172.20.0.0/24"
    vpn_psk           = local.externalid_token
    cidr              = local.hub_vpc_cidr
    ike_version       = "2"
    network_id        = "1"
    dpd_retryinterval = "5"
    mode_cfg          = true
    vpn_port          = "public"
  }]
  #-----------------------------------------------------------------------------------------------------
  # SPOKE
  #-----------------------------------------------------------------------------------------------------
  spoke_vpc_cidr = "10.1.0.0/24" // Range assigned to region1 student0

  spoke_srv_type = "t3.small"

  spoke = {
    id      = "student0"
    cidr    = local.spoke_vpc_cidr
    bgp-asn = local.hub[0]["bgp_asn_spoke"]
  }

  hubs = [for hub in local.hub :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = module.hub.fgt_eip_public
      hub_ip            = cidrhost(hub["vpn_cidr"], 1)
      site_ip           = ""
      hck_ip            = cidrhost(hub["vpn_cidr"], 1)
      vpn_psk           = module.hub_config.vpn_psk
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  #--------------------------------------------------------------------------------------------
  # Server LAB variables
  #--------------------------------------------------------------------------------------------
  # External ID token generated in deployent student
  externalid_token = data.terraform_remote_state.student_accounts.outputs.externalid_token
  random_url_db    = trimspace(random_string.db_url.result)

  # Instance type 
  srv_instance_type = "t3.large"

  # Git repository
  git_uri          = "https://github.com/jmvigueras/xpertsummit23_setup.git"
  git_uri_app_path = "/xpertsummit23_setup/0_modules/hub-server/"
  # LAB server FQDN
  lab_fqdn = "cloudlab.xpertsummit23.com"
  # DB
  db = {
    db_host  = "mysqldb"
    db_user  = "root"
    db_pass  = "L2e9TPd8LCJvAz7"
    db_name  = "students"
    db_table = "students"
    db_port  = "3306"
  }

  #--------------------------------------------------------------------------------------------
  # Student-0 server LAB variables
  #--------------------------------------------------------------------------------------------
  docker_image          = "swaggerapi/petstore"
  docker_port_internal  = "8080"
}




