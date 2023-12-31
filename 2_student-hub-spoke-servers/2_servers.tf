#--------------------------------------------------------------------------------------------
# Create LAB Server
#--------------------------------------------------------------------------------------------
// Create NI for server
resource "aws_network_interface" "lab_server" {
  subnet_id         = module.hub_vpc.subnet_ids["bastion"]
  security_groups   = [module.hub_vpc.sg_ids["bastion"]]
  private_ips       = [local.lab_srv_private_ip]
  source_dest_check = false
  tags = {
    Name = "${local.prefix}-lab-portal"
  }
}
# Create EIP active public NI for server test
resource "aws_eip" "lab_server" {
  domain            = "vpc"
  network_interface = aws_network_interface.lab_server.id
  tags = {
    Name = "${local.prefix}-lab-portal"
  }
}
# Deploy cluster master node
module "lab_server" {
  depends_on = [module.hub]
  source     = "./modules/new-instance_ni"

  keypair       = trimspace(aws_key_pair.keypair.key_name)
  instance_type = local.lab_srv_type
  linux_os      = "amazon"
  user_data     = data.template_file.srv_user_data.rendered
  ni_id         = aws_network_interface.lab_server.id

  tags = {
    Owner   = "${local.prefix}-lab-owner"
    Name    = "${local.prefix}-lab-portal"
    Project = local.tags["Project"]
  }
}
# Create user-data for server
data "template_file" "srv_user_data" {
  template = file("./templates/server_user-data.tpl")
  vars = {
    git_uri          = local.git_uri
    git_uri_app_path = local.git_uri_app_path
    docker_file      = data.template_file.srv_user_data_dockerfile.rendered
    nginx_config     = data.template_file.srv_user_data_nginx_config.rendered
    nginx_html       = data.template_file.srv_user_data_nginx_html.rendered
    redis_script     = ""

    db_host  = local.db["db_host"]
    db_user  = local.db["db_user"]
    db_pass  = local.db["db_pass"]
    db_name  = local.db["db_name"]
    db_table = local.db["db_table"]
    db_port  = local.db["db_port"]
  }
}
// Create dockerfile
data "template_file" "srv_user_data_dockerfile" {
  template = file("./templates/docker-compose.yaml")
  vars = {
    lab_fqdn      = local.lab_fqdn
    random_url_db = local.random_url_db
    db_host       = local.db["db_host"]
    db_user       = local.db["db_user"]
    db_pass       = local.db["db_pass"]
    db_name       = local.db["db_name"]
    db_table      = local.db["db_table"]
    db_port       = local.db["db_port"]
  }
}
// Create nginx config
data "template_file" "srv_user_data_nginx_config" {
  template = file("./templates/nginx_config.tpl")
  vars = {
    externalid_token = local.externalid_token
    random_url_db    = local.random_url_db
  }
}
// Create nginx html
data "template_file" "srv_user_data_nginx_html" {
  template = file("./templates/nginx_html.tpl")
  vars = {
    lab_fqdn = local.lab_fqdn
  }
}

#--------------------------------------------------------------------------------------------
# Create Student-0 server LAB
#--------------------------------------------------------------------------------------------
// Create NI for server
resource "aws_network_interface" "student_server" {
  subnet_id         = module.spoke_vpc.subnet_ids["bastion"]
  security_groups   = [module.spoke_vpc.sg_ids["bastion"]]
  private_ips       = [local.student_srv_private_ip]
  source_dest_check = false
  tags = {
    Name = "${local.prefix}-user-0-server"
  }
}
# Create EIP active public NI for server test
resource "aws_eip" "student_server" {
  domain            = "vpc"
  network_interface = aws_network_interface.student_server.id
  tags = {
    Name = "${local.prefix}-user-0-server"
  }
}
# Deploy cluster master node
module "student_server" {
  depends_on = [module.spoke]
  source     = "./modules/new-instance_ni"

  keypair       = trimspace(aws_key_pair.keypair.key_name)
  instance_type = local.student_srv_type
  linux_os      = "amazon"
  user_data     = data.template_file.student_server_user_data.rendered
  ni_id         = aws_network_interface.student_server.id

  tags = {
    Owner   = local.student_id
    Name    = "${local.prefix}-user-0-server"
    Project = local.tags["Project"]
  }
}
# Generate template file
data "template_file" "student_server_user_data" {
  template = file("./templates/student_user-data.tpl")
  vars = {
    docker_image         = local.docker_image
    docker_port_internal = local.docker_port_internal
    docker_port_external = "80"
    // docker_env = "-e SWAGGER_HOST=http://${module.spoke.fgt_eip_public} -e SWAGGER_BASE_PATH=/v2 -e SWAGGER_URL=http://${module.spoke.fgt_eip_public}"
    docker_env = "-e SWAGGER_HOST=http://${local.student_id}.${local.dns_zone_name} -e SWAGGER_BASE_PATH=/api -e SWAGGER_URL=http://${local.student_id}.${local.dns_zone_name}"
  }
}