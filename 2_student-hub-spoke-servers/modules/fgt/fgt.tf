# ------------------------------------------------------------------
# FGT instance
# ------------------------------------------------------------------
resource "aws_instance" "fgt" {
  ami                  = var.license_type == "byol" ? data.aws_ami_ids.fgt_amis_byol.ids[0] : data.aws_ami_ids.fgt_amis_payg.ids[0]
  instance_type        = var.instance_type
  availability_zone    = var.region[var.region_az]
  key_name             = var.keypair
  //iam_instance_profile = aws_iam_instance_profile.fgt-apicall-profile.name
  user_data            = var.fgt_config

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  root_block_device {
    encrypted = true
  }
  ebs_block_device {
    encrypted   = true
    device_name = "/dev/sdb"
  }
  // Create interface index 0 to avoid auto assination to default VPC
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.fgt_nis[0].id
  }

  tags = {
    Name = local.fgt_id
  }
}

# Get the last AMI Images from AWS MarektPlace FGT PAYG
data "aws_ami_ids" "fgt_amis_payg" {
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["FortiGate-VM64-AWSONDEMAND ${var.fgt_build}*"]
  }
}

# Get the last AMI Images from AWS MarektPlace FGT BYOL
data "aws_ami_ids" "fgt_amis_byol" {
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["FortiGate-VM64-AWS ${var.fgt_build}*"]
  }
}