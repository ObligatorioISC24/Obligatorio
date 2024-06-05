## webapp-server01
resource "aws_instance" "webapp-server01" {
  ami                    = var.instance_ami
  depends_on             = [aws_db_instance.obligatorio-rds]
  instance_type          = var.instance_type_name
  key_name               = var.private_key_name
  vpc_security_group_ids = [aws_security_group.obligatorio-sg.id]
  subnet_id              = aws_subnet.obligatorio-tf-subnet-a.id
  tags = {
    Name      = "webapp-server01"
    Terraform = "True"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file(var.private_key_path) 
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo yum install -y git",
      "sudo yum install -y mariadb105",
      "sudo chmod 777 /var/www/html",
      "git clone https://github.com/mauricioamendola/simple-ecomme.git /var/www/html",
      "sudo sed -i 's/localhost/${aws_db_instance.obligatorio-rds.address}/' /var/www/html/config.php",
      "wget https://raw.githubusercontent.com/mauricioamendola/simple-ecomme/master/dump.sql",
      "sudo mysql -h ${aws_db_instance.obligatorio-rds.address} -u root -pobligatorio idukan < dump.sql", ##Revisar como tomar la variable en vez de poner la clave
      "sudo systemctl restart httpd",
      "sudo mkdir /var/www/documentos",
      "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.obligatorio-efs.dns_name}:/   /var/www/documentos"
    ]
  }
}

## webapp-server02
resource "aws_instance" "webapp-server02" {
  ami                    = var.instance_ami
  depends_on             = [aws_db_instance.obligatorio-rds]
  instance_type          = var.instance_type_name
  key_name               = var.private_key_name
  vpc_security_group_ids = [aws_security_group.obligatorio-sg.id]
  subnet_id              = aws_subnet.obligatorio-tf-subnet-b.id
  tags = {
    Name      = "webapp-server02"
    Terraform = "True"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file(var.private_key_path) 
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo yum install -y git",
      "sudo yum install -y mariadb105",
      "sudo chmod 777 /var/www/html",
      "git clone https://github.com/mauricioamendola/simple-ecomme.git /var/www/html",
      "sudo sed -i 's/localhost/${aws_db_instance.obligatorio-rds.address}/' /var/www/html/config.php",
      "wget https://raw.githubusercontent.com/mauricioamendola/simple-ecomme/master/dump.sql",
      "sudo mysql -h ${aws_db_instance.obligatorio-rds.address} -u root -pobligatorio idukan < dump.sql",
      "sudo systemctl restart httpd",
      "sudo mkdir /var/www/documentos",
      "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.obligatorio-efs.dns_name}:/   /var/www/documentos"

    ]
  }
}
## BACKUP
resource "aws_instance" "backup-server" {
  ami                    = var.instance_ami
  depends_on             = [aws_db_instance.obligatorio-rds]
  instance_type          = var.instance_type_name
  key_name               = var.private_key_name
  vpc_security_group_ids = [aws_security_group.obligatorio-sg.id]
  subnet_id              = aws_subnet.obligatorio-tf-subnet-a.id
  tags = {
    Name      = "backup-server"
    Terraform = "True"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file(var.private_key_path) 
  }

  #Definicion de volumen para BACKUP
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs -t ext4 /dev/sdh && sudo mkdir /mnt/backup && sudo mount /dev/sdh /mnt/backup ",
      "sudo mkdir /mnt/nfs && sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.obligatorio-efs.dns_name}:/   /mnt/nfs",
      "sudo echo '${file("/home/santiago/Obligatorio/backup.sh")}' > backup.sh",
      "sudo chmod a+x backup.sh",
      "sudo yum install cronie -y && sudo systemctl enable crond.service && sudo systemctl start crond.service",
      "echo '0 23 * * * root backup.sh' | sudo tee -a /etc/crontab",
      "sudo systemctl restart crond"
    ]
  }
}
