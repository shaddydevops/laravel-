output "ec2_instance_public_ip" {
  value = aws_instance.web.public_ip
}

# modules/ec2/outputs.tf
output "public_ip" {
  value = aws_instance.web.public_ip
}

output "role_name" {
  value = aws_iam_role.ec2_role.name
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}