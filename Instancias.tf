resource "aws_instance" "InstanciaDesdeTerraform" {
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = "t2.micro"
  key_name               = "Terraformkey"
  tags = {
    Name      = "InstanciaDesdeTerraform"
    Terraform = "True" 
  }
}