#Lunch configuration, se especifica la ami, tipo de instancia, clave y valores a utilizar en el ASG
resource "aws_launch_configuration" "obligatorio-launch-config" {
  name_prefix   = "obligatorio-launch-config"
  image_id      = var.instance_ami  
  instance_type = var.instance_type_name      
  key_name      = var.private_key_name  

  security_groups = [
    aws_security_group.obligatorio-sg.id  
  ]

  lifecycle {
    create_before_destroy = true
  }
  #Se especifica los comandos a ejecutar cuando se despliega cada instancia via el ASG
  user_data = <<-EOF
    #!/bin/bash
    echo 'export DB_HOST="${aws_db_instance.obligatorio-rds.address}"' | sudo tee -a /etc/environment
    echo 'export DB_PASS="${var.DB_PASSWORD}"' | sudo tee -a /etc/environment
    echo 'export NFS="${aws_efs_file_system.obligatorio-efs.dns_name}"' | sudo tee -a /etc/environment
    echo 'export RDS="${aws_db_instance.obligatorio-rds.address}"' | sudo tee -a /etc/environment
    wget -P /home/ec2-user/ https://raw.githubusercontent.com/ObligatorioISC24/Obligatorio/main/Codigo/despliegue.sh
    chmod a+x /home/ec2-user/despliegue.sh
    sudo /home/ec2-user/despliegue.sh
    EOF
}

resource "aws_autoscaling_group" "obligatorio-asg" {
  name                      = "obligatorio-asg"
  launch_configuration     = aws_launch_configuration.obligatorio-launch-config.id
  vpc_zone_identifier       = [
    aws_subnet.obligatorio-tf-subnet-a.id,  # ID de la subred en la zona de disponibilidad A
    aws_subnet.obligatorio-tf-subnet-b.id,  # ID de la subred en la zona de disponibilidad B
  ]
  min_size                  = 2  # Mínimo número de instancias
  max_size                  = 3  # Máximo número de instancias
  desired_capacity          = 2  # Capacidad deseada de instancias

  # Opciones adicionales (opcionales)
  health_check_type         = "EC2"
  health_check_grace_period = 300  # Período de gracia antes de las verificaciones de estado
  force_delete              = true  

  target_group_arns = [aws_lb_target_group.target_group.arn] #Asigna las instancias al ALB

}
