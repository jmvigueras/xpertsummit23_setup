output "iam-user_console-password" {
  sensitive = true
  value = {
    user     = aws_iam_user_login_profile.user_login-profile.*.user
    password = aws_iam_user_login_profile.user_login-profile.*.password
  }
}

output "iam-user_access-key" {
  sensitive = true
  value = {
    user       = aws_iam_access_key.user_access_key.*.user
    access_key = aws_iam_access_key.user_access_key.*.id
    secret_key = aws_iam_access_key.user_access_key.*.secret
  }
}

output "iam-user_arn" {
  sensitive = true
  value     = aws_iam_user.user.*.arn
}
