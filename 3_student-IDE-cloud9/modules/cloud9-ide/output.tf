output "cloud9-env_url" {
  value = {
    url     = "https://${var.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.cloud9_env.id}"
    user    = var.user_name
  }
}