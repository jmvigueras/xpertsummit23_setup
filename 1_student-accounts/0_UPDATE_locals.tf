locals {
  # Provide a common tag prefix value that will be used in the name tag for all resources
  prefix = "xs23"

  # Tags
  tags = {
    Project = "xpertsummit23"
  }

  # List of regions where deploy users
  regions = [
    "eu-west-1",
    "eu-west-2",
    "eu-west-3"
  ]

  # Number of user peer region
  user_number_peer_region = 2

  # Path prefix for users (regex /path-prefix/)
  user_path_prefix = "/xpertsummit23/"
}

#-------------------------------------------------------------------------------------
# Necessary data and resources
#-------------------------------------------------------------------------------------
# Get account id
data "aws_caller_identity" "current" {}

# Create new random string External ID for assume role
resource "random_string" "externalid_token" {
  length  = 30
  special = false
  numeric = true
}
