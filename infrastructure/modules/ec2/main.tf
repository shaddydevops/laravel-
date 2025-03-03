resource "aws_instance" "web" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.ec2_sg.name]  # Attach security group

  tags = {
    Name = "clms-ec2"
  }
}
