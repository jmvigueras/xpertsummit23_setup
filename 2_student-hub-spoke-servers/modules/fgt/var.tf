# AWS resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

variable "suffix" {
  type    = string
  default = "1"
}

variable "fgt_id" {
  type    = string
  default = null
}

variable "tags" {
  description = "Attribute for tag Enviroment"
  type        = map(any)
  default = {
    Project = "terraform"
  }
}

variable "region" {
  type = map(any)
  default = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1c"
  }
}

variable "region_az" {
  type    = string
  default = "az1"
}

variable "fgt_config" {
  type    = string
  default = ""
}

// AMI
variable "fgt-ami" {
  type    = string
  default = "null"
}

variable "keypair" {
  type    = string
  default = "null"
}

variable "instance_type" {
  description = "Provide the instance type for the FortiGate instances"
  type        = string
  default     = "c6i.large"
}

variable "fgt_ni_index" {
  type    = list(string)
  default = ["public", "private", "mgmt"]
}

variable "sg_ids" {
  type    = map(string)
  default = null
}

variable "fgt_cidrhost" {
  type    = number
  default = 10
}

variable "subnet_ids" {
  type    = map(string)
  default = null
}

variable "rt_ids" {
  type    = map(string)
  default = null
}

variable "subnet_cidrs" {
  type    = map(string)
  default = null
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  type    = string
  default = "payg"
}

variable "fgt_build" {
  type    = string
  default = "build1517"
}