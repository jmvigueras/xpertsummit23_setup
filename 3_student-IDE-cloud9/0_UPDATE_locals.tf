locals {
  # Provide a common tag prefix value that will be used in the name tag for all resources
  prefix = "xs23"

  # Tags
  tags = {
    Project = "xpertsummit23"
  }

  # Region to deploy AWS Cloud9 instances
  region = {
    id  = "eu-central-1"
    az1 = "eu-central-1a"
    az2 = "eu-central-1c"
  }

  # Number of user peer region
  vpc_cloud9_cidr = "172.30.0.0/23"

  # Path prefix for users (regex /path-prefix/)
  user_path_prefix = "/xpertsummit23/"
}