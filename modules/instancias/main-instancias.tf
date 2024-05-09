resource "aws_instance" "InstanciaDesdeTerraform" {
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = var.instance_type
  key_name               = "Terraformkey"
  tags = {
    Name      = var.instance_name
    Terraform = "True" 
  }
}