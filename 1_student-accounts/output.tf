
output "iam-user_console-password" {
  sensitive = true
  value     = module.iam-users.*.iam-user_console-password
}

output "iam-user_access-key" {
  sensitive = true
  value     = module.iam-users.*.iam-user_access-key
}

output "iam-user_arn" {
  sensitive = true
  value     = module.iam-users.*.iam-user_arn
}

output "iam-user_account_id" {
  sensitive = true
  value     = data.aws_caller_identity.current.account_id
}

output "externalid_token" {
  sensitive = true
  value     = random_string.externalid_token.result
}

output "user_path_prefix" {
  sensitive = true
  value     = local.user_path_prefix
}

