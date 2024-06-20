#!/bin/bash

NFS=$NFS
RDS=$RDS
DB_PASS=$DB_PASS

sudo amazon-linux-extras enable epel
sudo yum install -y epel-release
sudo yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php54
sudo yum install -y php php-cli php-common php-mbstring php-xml php-mysql php-fpm
sudo yum install -y httpd
sudo yum install -y git
sudo yum install -y mariadb.x86_64
sudo mkdir /var/www/html/img && sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $NFS:/   /var/www/html/img 
sudo cd /home/ec2-user #nos posicionamos en el home para que el git clone y los wget no queden en el /
git clone https://github.com/ObligatorioISC24/ecommerce.git #clonado del repo en el home para poder copiar las imagenes hacia el NFS
sudo mv /home/ec2-user/ecommerce/img/* /var/www/html/img/ && rm -r /home/ec2-user/ecommerce/img/ 
sudo mv /home/ec2-user/ecommerce/* /var/www/html/ #movimiento de la app al directorio correcto
sudo sed -i "s/localhost/$RDS/" /var/www/html/config.php 
sudo sed -i "s/define('DB_PASSWORD', 'root')/define('DB_PASSWORD', "$DB_PASS")/" /var/www/html/config.php 
sudo chown -R apache:apache /var/www #cambio de usuario y grupo por el de apache
wget https://raw.githubusercontent.com/ObligatorioISC24/ecommerce/main/dump.sql
wget https://raw.githubusercontent.com/ObligatorioISC24/Obligatorio/main/Codigo/dump.sh
sudo chmod a+x dump.sh
sudo /home/ec2-user/dump.sh
sudo systemctl start httpd