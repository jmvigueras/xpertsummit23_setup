#-----------------------------------------------------------------------------------------------------
# VM LINUX for testing
#-----------------------------------------------------------------------------------------------------
// Create Amazon Linux EC2 Instance
resource "aws_instance" "vm" {
  ami           = var.linux_os == "ubuntu" ? data.aws_ami.ami_ubuntu.id : data.aws_ami.ami_amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.keypair
  user_data     = var.user_data == null ? file("${path.module}/templates/user-data.sh") : var.user_data

  root_block_device {
    volume_size           = var.disk_size
    volume_type           = var.disk_type
    delete_on_termination = true
    encrypted             = true
  }

  network_interface {
    device_index         = 0
    network_interface_id = var.ni_id
  }

  tags = var.tags
}

// Retrieve AMI info
data "aws_ami" "ami_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// Amazon Linux 2 AMI
data "aws_ami" "ami_amazon_linux_2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}



