module "ec2" {
  source         = "./modules/ec2"
  instance_type  = var.instance_type
  key_name       = var.key_name
  ami_id         = var.ami_id
  security_group_name = var.security_group_name
}
