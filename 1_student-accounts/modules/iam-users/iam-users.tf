#-------------------------------------------------------------------------------------
# Create users
#-------------------------------------------------------------------------------------
# Create users
resource "aws_iam_user" "user" {
  count         = var.user_number
  name          = "${var.prefix}-${var.region}-user-${count.index + 1}"
  path          = var.user_path_prefix
  force_destroy = true

  tags = var.tags
}
# Create group membership to each user
resource "aws_iam_user_group_membership" "user_group" {
  count = var.user_number
  user  = aws_iam_user.user[count.index].name

  groups = [var.group_name]
}
# Create login console profile
resource "aws_iam_user_login_profile" "user_login-profile" {
  count = var.user_number
  user  = aws_iam_user.user[count.index].name
}
# Create an Access-Keys for user
resource "aws_iam_access_key" "user_access_key" {
  count = var.user_number
  user  = aws_iam_user.user[count.index].name
}
#######################################################################################
# Role for Terraform deployment with rights
// Create role for deploy with Terraform
resource "aws_iam_role" "user_terraform-role" {
  count              = var.user_number
  name               = "role-${var.prefix}-${var.region}-user-${count.index + 1}"
  assume_role_policy = data.template_file.data-user_role-trust-policy[count.index].rendered

  tags = var.tags
}
// Create policy
resource "aws_iam_policy" "user_terraform-policy" {
  count       = var.user_number
  name        = "policy-${var.prefix}-${var.region}-user-${count.index + 1}"
  path        = var.user_path_prefix
  description = "Policies for terraform role user-${count.index + 1}"
  policy      = data.template_file.data-user_role-policy[count.index].rendered

  tags = var.tags
}
// Asociate policy to role
resource "aws_iam_policy_attachment" "user_terraform-role_attach" {
  count      = var.user_number
  name       = "attach-${var.prefix}-${var.region}-user-${count.index + 1}"
  roles      = [aws_iam_role.user_terraform-role[count.index].name]
  policy_arn = aws_iam_policy.user_terraform-policy[count.index].arn
}

#######################################################################################
# Data
// Read Route53 Zone info
data "aws_route53_zone" "data_dns_zone" {
  name         = "${var.dns_domain}."
  private_zone = false
}
// Template to create user role policy
data "template_file" "data-user_role-policy" {
  count    = var.user_number
  template = file("./templates/role-policy.json")
  vars = {
    region      = var.region
    user_name   = aws_iam_user.user[count.index].name
    dns_zone_id = var.dns_zone_id == null ? data.aws_route53_zone.data_dns_zone.zone_id : var.dns_zone_id
    dns_domain  = var.dns_domain
    prefix      = var.prefix
  }
}
// Template to create user trust role policy
data "template_file" "data-user_role-trust-policy" {
  count    = var.user_number
  template = file("./templates/role-trust-policy.json")
  vars = {
    user_arn         = aws_iam_user.user[count.index].arn
    externalid_token = var.externalid_token
  }
}

