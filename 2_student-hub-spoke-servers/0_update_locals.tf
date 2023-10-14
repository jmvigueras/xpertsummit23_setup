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
  # DNS and FortiWEB
  #-----------------------------------------------------------------------------------------------------
  # AWS Route 53 DNS zone name
  dns_zone_name = "xpertsummit-es.com"
  # Fortiweb Cloud template ID
  fwb_cloud_template = "b4516b99-3d08-4af8-8df7-00246da409cf"
  # FortiWEB Cloud regions where deploy
  fortiweb_region = "eu-central-1"
  # FortiWEB Cloud platform names
  fortiweb_platform = "AWS"
  # LAB server FQDN
  lab_fqdn = "${local.prefix}.${data.aws_route53_zone.data_dns_zone.name}"
  #-----------------------------------------------------------------------------------------------------
  # FGT General
  #-----------------------------------------------------------------------------------------------------
  admin_port = "8443"
  admin_cidr = "0.0.0.0/0"

  fgt_hub_type = "c6i.xlarge"
  fgt_build    = "build1517"
  license_type = "payg"
  # IP in subnet allocated to fortigate intefaces 
  fgt_cidrhost = "10"
  #-----------------------------------------------------------------------------------------------------
  # HUB
  #-----------------------------------------------------------------------------------------------------
  hub_vpc_cidr = "10.10.10.0/24"

  hub = [{
    id                = "hub"
    bgp_asn_hub       = "65000"
    bgp_asn_spoke     = "65000"
    vpn_cidr          = "10.10.20.0/24"
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
  fgt_spoke_type   = "c6i.large"
  student_srv_type = "t3.small"

  # Student server IP in bastion subnet
  student_srv_private_ip = cidrhost(module.spoke_vpc.subnet_cidrs["bastion"], 10) // "x.x.x.202"

  spoke_vpc_cidr = "10.1.0.0/24" // Range assigned to region1 student0

  spoke = {
    id      = "user-0"
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
  # Lab server IP in bastion subnet
  lab_srv_private_ip = cidrhost(module.hub_vpc.subnet_cidrs["bastion"], 10) // "x.x.x.202"

  # External ID token generated in deployent student
  externalid_token = data.terraform_remote_state.student_accounts.outputs.externalid_token
  random_url_db    = trimspace(random_string.db_url.result)

  # Instance type 
  lab_srv_type = "t3.large"

  # Git repository
  git_uri          = "https://github.com/jmvigueras/xpertsummit23_setup.git"
  git_uri_app_path = "/xpertsummit23_setup/0_modules/hub-server/"

  # DB
  db = {
    db_host  = "mysqldb"
    db_user  = "root"
    db_pass  = local.random_url_db
    db_name  = "students"
    db_table = "students"
    db_port  = "3306"
  }
  #--------------------------------------------------------------------------------------------
  # Student-0 server LAB variables
  #--------------------------------------------------------------------------------------------
  docker_image         = "swaggerapi/petstore"
  docker_port_internal = "8080"
  student_id           = "${local.prefix}-${local.region["id"]}-user-0"
}




