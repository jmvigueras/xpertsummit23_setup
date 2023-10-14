#-------------------------------------------------------------------------------------
# Create users with iam-users module
# - create user peer region
# - allocate user in path prefix
# - basic permissons granted by UserGroup
# - create role for each user to assume when deploying with Terraform
#-------------------------------------------------------------------------------------
module "iam-users" {
  source = "./modules/iam-users"
  count  = length(local.regions)

  prefix           = local.prefix
  externalid_token = random_string.externalid_token.result
  tags             = local.tags
  user_number      = local.user_number_peer_region
  user_path_prefix = local.user_path_prefix
  region           = local.regions[count.index]
  dns_domain       = local.dns_domain
  group_name       = aws_iam_group.group[count.index].name
}