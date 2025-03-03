variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "AWS Key Pair for SSH"
  type        = string
}

variable "ami_id" {
  description = "Amazon Machine Image (AMI) ID"
  type        = string
}

variable "security_group_name" {
  description = "Security Group Name"
  type        = string
  default     = "clms-sg"
}
