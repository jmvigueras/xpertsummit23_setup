##############################################################################################################
#
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment -
#
##############################################################################################################

variable "instance_type" {
  description = "Instance type for cloud9 IDE"
  default     = "t2.micro"
}

variable "user_arn" {
  description = "User ARN"
  type        = string
  default     = "arn:aws:iam::xxx:user/xxx/user-1"
}

variable "user_name" {
  description = "User Name"
  type        = string
  default     = "user-1"
}

# Prefix for all resources created for this deployment in AWS
variable "tags" {
  description = "Attribute for tag Enviroment"
  type        = map(any)
  default     = {
    project   = "xpertsummit22"
    Name      = "cloud9-ide"
  }
}

variable "subnet_id" {
  description = "cloud9 instances subnet id"
  default     = "subnet-xxx"
}

variable "region" {
  description = "Region where Cloud9 IDE are deployed"
  default     = "eu-central-1"
}

