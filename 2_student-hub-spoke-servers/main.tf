#--------------------------------------------------------------------------------------------
# Import data from deployment 1_student-accounts
#--------------------------------------------------------------------------------------------
data "terraform_remote_state" "student_accounts" {
  backend = "local"
  config = {
    path = "../1_student-accounts/terraform.tfstate"
  }
}
#--------------------------------------------------------------------------
# Necessary variables if not provided
#--------------------------------------------------------------------------
# Create key-pair
resource "aws_key_pair" "keypair" {
  key_name   = "${local.prefix}-keypair-${trimspace(random_string.keypair.result)}"
  public_key = tls_private_key.ssh.public_key_openssh
}
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "./ssh-key/${local.prefix}-ssh-key.pem"
  file_permission = "0600"
}
# Get my public IP
data "http" "my-public-ip" {
  url = "http://ifconfig.me/ip"
}
# Create new random API key to be provisioned in FortiGates.
resource "random_string" "api_key" {
  length  = 30
  special = false
  numeric = true
}
# Create new random API key to be provisioned in FortiGates.
resource "random_string" "vpn_psk" {
  length  = 30
  special = false
  numeric = true
}
// Create random string for api_key name
resource "random_string" "keypair" {
  length  = 5
  special = false
  numeric = false
}
// Create random string for DB phpmyadmin url name
resource "random_string" "db_url" {
  length  = 10
  special = false
  numeric = false
}