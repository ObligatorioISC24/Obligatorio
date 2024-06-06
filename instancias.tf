## webapp-server01
resource "aws_instance" "webapp-server01" {
  ami                    = var.instance_ami
  depends_on             = [aws_db_instance.obligatorio-rds, aws_efs_file_system.obligatorio-efs]
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
      "sudo amazon-linux-extras enable epel",
      "sudo yum install -y epel-release",
      "sudo yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm",
      "sudo yum-config-manager --enable remi-php54",
      "sudo yum install -y php php-cli php-common php-mbstring php-xml php-mysql php-fpm",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo yum install -y git",
      "sudo yum install -y mariadb.x86_64",
      "sudo chmod 777 /var/www/html",
      "sudo mkdir /var/www/html/img && sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.obligatorio-efs.dns_name}:/   /var/www/html/img",
      "git clone https://github.com/ObligatorioISC24/ecommerce.git",
      "sudo mv /home/ec2-user/ecommerce/img/* /var/www/html/img/ && rm -r /home/ec2-user/ecommerce/img/",
      "sudo mv /home/ec2-user/ecommerce/* /var/www/html/",
      "sudo sed -i 's/localhost/${aws_db_instance.obligatorio-rds.address}/' /var/www/html/config.php",
      "wget https://raw.githubusercontent.com/ObligatorioISC24/ecommerce/main/dump.sql",
      "sudo mysql -h ${aws_db_instance.obligatorio-rds.address} -u ${var.DB_USER} -p${var.DB_PASSWORD} ${var.DB_DATABASE} < dump.sql", ##Revisar como tomar la variable en vez de poner la clave
      "sudo systemctl restart httpd"

    ]
  }
}

## webapp-server02
resource "aws_instance" "webapp-server02" {
  ami                    = var.instance_ami
  depends_on             = [aws_db_instance.obligatorio-rds, aws_efs_file_system.obligatorio-efs]
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
      "sudo amazon-linux-extras enable epel",
      "sudo yum install -y epel-release",
      "sudo yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm",
      "sudo yum-config-manager --enable remi-php54",
      "sudo yum install -y php php-cli php-common php-mbstring php-xml php-mysql php-fpm",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo yum install -y git",
      "sudo yum install -y mariadb.x86_64",
      "sudo chmod 777 /var/www/html",
      "sudo mkdir /var/www/html/img && sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.obligatorio-efs.dns_name}:/   /var/www/html/img",
      "git clone https://github.com/ObligatorioISC24/ecommerce.git",
      "sudo mv /home/ec2-user/ecommerce/img/* /var/www/html/img/ && rm -r /home/ec2-user/ecommerce/img/",
      "sudo mv /home/ec2-user/ecommerce/* /var/www/html/",
      "sudo sed -i 's/localhost/${aws_db_instance.obligatorio-rds.address}/' /var/www/html/config.php",
      "wget https://raw.githubusercontent.com/ObligatorioISC24/ecommerce/main/dump.sql",
      "sudo mysql -h ${aws_db_instance.obligatorio-rds.address} -u ${var.DB_USER} -p${var.DB_PASSWORD} ${var.DB_DATABASE} < dump.sql", ##Revisar como tomar la variable en vez de poner la clave
      "sudo systemctl restart httpd"
      
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
      "sudo echo '${file(var.script_path)}' > backup.sh",
      "sudo chmod a+x backup.sh",
      "sudo yum install cronie -y && sudo systemctl enable crond.service && sudo systemctl start crond.service",
      "echo '0 23 * * * root backup.sh' | sudo tee -a /etc/crontab",
      "sudo systemctl restart crond"
    ]
  }
}
