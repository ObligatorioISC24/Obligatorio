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
      "sudo mkfs -t ext4 /dev/sdh && sudo mkdir /mnt/backup && sudo mount /dev/sdh /mnt/backup ", #Montaje de nuevo disco
      "sudo mkdir /mnt/nfs && sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.obligatorio-efs.dns_name}:/   /mnt/nfs", #Montaje de EFS
      "sudo echo '${file(var.script_path)}' > backup.sh", #copia del script desde pc local hacia instancia
      "sudo chmod a+x backup.sh",
      "sudo yum install cronie -y && sudo systemctl enable crond.service && sudo systemctl start crond.service",
      "echo '0 23 * * * root /home/ec2-user/backup.sh' | sudo tee -a /etc/crontab", #ejecucion del script todos los dias a las 23hs
      "sudo systemctl restart crond"
    ]
  }
}
