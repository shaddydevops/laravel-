output "ec2_instance_public_ip" {
  value = aws_instance.web.public_ip
}

# modules/ec2/outputs.tf
output "public_ip" {
  value = aws_instance.your_ec2_resource_name.public_ip
}