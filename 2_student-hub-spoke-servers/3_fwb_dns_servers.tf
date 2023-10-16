#-----------------------------------------------------------------------------------------------------
# Create new APP in FortiWEB Cloud - lab server 
#-----------------------------------------------------------------------------------------------------
# Template command to create an APP on FortiWEB Cloud and export CNAME to file named "file_name"
data "template_file" "fwb_cloud_lab_server" {
  template = file("./templates/fwb_cloud_new_app.tpl")
  vars = {
    token          = var.fwb_cloud_token
    region         = local.fortiweb_region
    app_name       = "${local.prefix}-portal"
    domain_name    = local.lab_fqdn
    server_ip      = module.hub.fgt_eip_public
    server_port    = "80"
    server_country = "Frankfurt"
    template_id    = local.fwb_template_lab_srv
    file_name      = "lab_server_cname_record.txt"
    platform       = local.fortiweb_platform
  }
}
# Launch command (Create APP in FortiWEB Cloud)
resource "null_resource" "fwb_cloud_lab_server" {
  provisioner "local-exec" {
    command = data.template_file.fwb_cloud_lab_server.rendered
  }
}
#-----------------------------------------------------------------------------------------------------
# Create new Route53 record - lab server 
#-----------------------------------------------------------------------------------------------------
# Read FortiWEB new APP CNAME file after FWB Cloud command be applied
data "local_file" "fwb_cloud_lab_server_fqdn" {
  depends_on = [null_resource.fwb_cloud_lab_server]
  filename   = "lab_server_cname_record.txt"
}
# Create Route53 record entry with FWB APP CNAME
resource "aws_route53_record" "lab_server_cname" {
  zone_id = data.aws_route53_zone.data_dns_zone.zone_id
  name    = local.lab_fqdn
  type    = "CNAME"
  ttl     = "30"
  records = [data.local_file.fwb_cloud_lab_server_fqdn.content]
}
#-----------------------------------------------------------------------------------------------------
# Create new APP in FortiWEB Cloud - student server
#-----------------------------------------------------------------------------------------------------
# Template command to create an APP on FortiWEB Cloud and export CNAME to file named "file_name"
data "template_file" "fwb_cloud_student_server" {
  template = file("./templates/fwb_cloud_new_app.tpl")
  vars = {
    token          = var.fwb_cloud_token
    region         = local.fortiweb_region
    app_name       = "${local.student_id}-app"
    domain_name    = "${local.student_id}.${data.aws_route53_zone.data_dns_zone.name}"
    server_ip      = module.spoke.fgt_eip_public
    server_port    = "80"
    server_country = "Frankfurt"
    template_id    = local.fwb_template_student_srv
    file_name      = "student_server_cname_record.txt"
    platform       = local.fortiweb_platform
  }
}
# Launch command (Create APP in FortiWEB Cloud)
resource "null_resource" "fwb_cloud_student_server" {
  provisioner "local-exec" {
    command = data.template_file.fwb_cloud_student_server.rendered
  }
}
#-----------------------------------------------------------------------------------------------------
# Create new Route53 record - lab server 
#-----------------------------------------------------------------------------------------------------
# Read FortiWEB new APP CNAME file after FWB Cloud command be applied
data "local_file" "fwb_cloud_student_server_fqdn" {
  depends_on = [null_resource.fwb_cloud_student_server]
  filename   = "student_server_cname_record.txt"
}
# Create Route53 record entry with FWB APP CNAME
resource "aws_route53_record" "student_server_cname" {
  zone_id = data.aws_route53_zone.data_dns_zone.zone_id
  name    = local.lab_fqdn
  type    = "CNAME"
  ttl     = "30"
  records = [data.local_file.fwb_cloud_student_server_fqdn.content]
}
#-----------------------------------------------------------------------------------------------------
# Define FortiWEB Cloud token variable (update in terraform.tfvars)
#-----------------------------------------------------------------------------------------------------
variable "fwb_cloud_token" {}
#-----------------------------------------------------------------------------------------------------
# Read data of AWS Route53 zone
#-----------------------------------------------------------------------------------------------------
# Read Route53 Zone info
data "aws_route53_zone" "data_dns_zone" {
  name         = "${local.dns_zone_name}."
  private_zone = false
}