#------------------------------------------------------------------------------
# Create FGT HUB
#------------------------------------------------------------------------------
// Create FGT config
module "hub_config" {
  source = "./modules/fgt_config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)

  subnet_cidrs     = module.hub_vpc.subnet_cidrs
  fgt_extra_config = data.template_file.hub_fgt_extra_config.rendered
  fgt_cidrhost     = local.fgt_cidrhost

  config_fgcp = true
  config_hub  = true
  hub         = local.hub

  vpc-spoke_cidr = [module.hub_vpc.subnet_cidrs["bastion"]]
}
# Data template extra-config fgt (Create new VIP to lab server and policies to allow traffic)
data "template_file" "hub_fgt_extra_config" {
  template = file("./templates/fgt_extra_config.tpl")
  vars = {
    external_ip   = cidrhost(module.hub_vpc.subnet_cidrs["public"], local.fgt_cidrhost)
    mapped_ip     = local.lab_srv_private_ip
    external_port = "80"
    mapped_port   = "80"
    public_port   = "port1"
    private_port  = "port2"
    suffix        = "80"
  }
}
// Create FGT HUB
module "hub" {
  source = "./modules/fgt"

  prefix        = local.prefix
  region        = local.region
  instance_type = local.fgt_hub_type
  keypair       = trimspace(aws_key_pair.keypair.key_name)

  fgt_id       = "${local.hub[0]["id"]}-fgt"
  license_type = local.license_type
  fgt_build    = local.fgt_build
  fgt_config   = module.hub_config.fgt_config
  fgt_cidrhost = local.fgt_cidrhost

  subnet_ids   = module.hub_vpc.subnet_ids
  subnet_cidrs = module.hub_vpc.subnet_cidrs
  sg_ids       = module.hub_vpc.sg_ids
  rt_ids       = module.hub_vpc.rt_ids
}
// Create VPC FGT HUB
module "hub_vpc" {
  source = "./modules/fgt_vpc_1az"

  prefix     = "${local.prefix}-vpc-hub"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = local.region

  vpc_cidr = local.hub_vpc_cidr
}
#------------------------------------------------------------------------------
# Create FGT SPOKE
#------------------------------------------------------------------------------
// Create FGT spoke config
module "spoke_config" {
  source = "./modules/fgt_config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)

  subnet_cidrs     = module.spoke_vpc.subnet_cidrs
  fgt_extra_config = data.template_file.spoke_fgt_extra_config.rendered
  fgt_cidrhost     = local.fgt_cidrhost

  config_fgcp  = true
  config_spoke = true
  spoke        = local.spoke
  hubs         = local.hubs

  vpc-spoke_cidr = [module.spoke_vpc.subnet_cidrs["bastion"]]
}
# Data template extra-config fgt (Create new VIP to lab server and policies to allow traffic)
data "template_file" "spoke_fgt_extra_config" {
  template = file("./templates/fgt_extra_config.tpl")
  vars = {
    external_ip   = cidrhost(module.spoke_vpc.subnet_cidrs["public"], local.fgt_cidrhost)
    mapped_ip     = local.student_srv_private_ip
    external_port = "80"
    mapped_port   = "80"
    public_port   = "port1"
    private_port  = "port2"
    suffix        = "80"
  }
}
// Create FGT spoke
module "spoke" {
  source = "./modules/fgt"

  prefix        = local.prefix
  region        = local.region
  instance_type = local.fgt_spoke_type
  keypair       = trimspace(aws_key_pair.keypair.key_name)

  fgt_id       = "${local.spoke["id"]}-fgt"
  license_type = local.license_type
  fgt_build    = local.fgt_build
  fgt_config   = module.spoke_config.fgt_config
  fgt_cidrhost = local.fgt_cidrhost

  subnet_ids   = module.spoke_vpc.subnet_ids
  subnet_cidrs = module.spoke_vpc.subnet_cidrs
  sg_ids       = module.spoke_vpc.sg_ids
  rt_ids       = module.spoke_vpc.rt_ids
}
// Create VPC spoke
module "spoke_vpc" {
  source = "./modules/fgt_vpc_1az"

  prefix     = "${local.prefix}-vpc-spoke"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = local.region

  vpc_cidr = local.spoke_vpc_cidr
}