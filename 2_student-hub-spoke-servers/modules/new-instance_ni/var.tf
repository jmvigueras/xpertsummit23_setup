# AWS resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

variable "suffix" {
  type    = string
  default = "1"
}

variable "tags" {
  description = "Attribute for tag Enviroment"
  type        = map(any)
  default = {
    Owner   = "eu-west-1-user-0"
    Name    = "user-0-vm"
    Project = "xpertsummit23"
  }
}

variable "ni_id" {
  type    = string
  default = null
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "public_ip" {
  type    = bool
  default = true
}

variable "security_groups" {
  type    = list(string)
  default = null
}

variable "keypair" {
  type    = string
  default = null
}

variable "disk_size" {
  type        = number
  description = "Volumen size of root volumen of Linux Server"
  default     = 10
}

variable "disk_type" {
  type        = string
  description = "Volumen type of root volumen of Linux Server."
  default     = "gp2"
}

variable "user_data" {
  type        = string
  description = "Cloud-init script"
  default     = null
}

variable "iam_profile" {
  type    = string
  default = null
}

variable "linux_os" {
  type    = string
  default = "ubuntu"
}