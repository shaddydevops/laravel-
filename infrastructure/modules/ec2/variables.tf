variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key name for EC2"
  type        = string
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
  default     = "ec2_security_group"
}

# variable "instance_name" {
#   description = "Name tag for the EC2 instance"
#   type        = string
# }
