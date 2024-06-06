## Obligatorio Soluciones Cloud

## Introducción

Este repo contiene el código en terraform necesario para desplegar la infraestructura en AWS solicitada en el obligatorio de soluciones cloud.
Descripción de la Arquitectura:
- Un LoadBalancer HTTP/S
- Dos servidores Web
- Una base de datos relacional
- Un servidor donde se almacenan documentos estáticos
- Un servidor de backup con persistencia

## Diagrama

A continuación demostraremos la topologia de la infraestrucura con una ilustración implementada describiendo todos los componentes que integran la misma, explicandose en un VPC el cual contiene dos zonas de disponibilidad dentro de las mismas un security group con 2 instancias pertenecientes a subnets diferentes, una base de datos relacional, un servidor de EFS donde se almacenan documentos estaticos,servidor de backup con persistencia y adicionalmente un Application Load Balancer HTTPS.

<p align = "center"> 
<img src = "Diagrama.png">
</p>

## Requerimientos

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Git](https://github.com/git-guides/install-git)

## Despliegue

- Clonar el repo localmente 
- Editar en el archivo obligatorio_vars.tfvars con los valores para las variables
- Configurar las credenciales de AWS en el archivo credentials
- Inicializar el directorio de trabajo con terraform init
- Ejecutar el codigo con terraform apply -var-file="obligatorio_vars.tfvars"

[![asciicast](https://asciinema.org/a/dhtUDZOmstMq37KSB8gmyeTCt.svg)](https://asciinema.org/a/dhtUDZOmstMq37KSB8gmyeTCt)

## Remote-exec
 En este apartado explicaremos brevemente las implementaciones que tenemos dentro de la configuración del "remote-exec" que poseemos en nuestros servidores.

 Este script de ejecución remota en AWS realiza una serie de pasos para configurar un entorno de servidor web con PHP y una base de datos MySQL, clonar un repositorio de GitHub y configurar una aplicación web.

Este script es útil para configurar rápidamente un entorno de desarrollo o producción para una aplicación web en AWS, a continuación dejaremos un pequeño desgloce en 5 grandes pasos de lo que realiza el remote-exec.

## -1 Configuración de servidor web y PHP:

Habilita repositorios adicionales de paquetes.
Instala PHP, Apache (httpd), y otros paquetes necesarios para ejecutar aplicaciones web en PHP.

## -2 Preparación de la base de datos:

Instala el servidor de base de datos MariaDB.
Configura la conexión de la aplicación web con la base de datos, actualizando la configuración en el archivo config.php.

## -3 Clonación y despliegue de la aplicación web:

Clona un repositorio de GitHub que contiene la aplicación web de ecommerce.
Mueve los archivos de la aplicación web al directorio raíz del servidor web.
Mueve las imágenes de la aplicación web al directorio correspondiente en el servidor web.

## -4 Configuración de la base de datos:

Descarga un archivo SQL de un repositorio remoto.
Importa la base de datos utilizando MySQL desde el archivo SQL descargado.

## -5 Finalización y reinicio del servidor web:

Reinicia el servidor web Apache para aplicar todas las configuraciones y cambios realizados.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.52.0 |


## Resources

| Name | Type |
|------|------|
| [aws_db_instance.obligatorio-rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.network-group-obligatorio](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_efs_file_system.obligatorio-efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.obligatorio-efs-mount-tgA](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_efs_mount_target.obligatorio-efs-mount-tgB](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_instance.backup-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.webapp-server01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.webapp-server02](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.obligatorio-ig](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_lb.alb-obligatorio](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.my_alb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.targetA](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.attachment-A](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attachment-B](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_route_table.obligatorio-rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.subneta](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.subnetb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.obligatorio-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.obligatorio-sg-EFS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.obligatorio-sg-RDS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.obligatorio-tf-subnet-a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.obligatorio-tf-subnet-b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.obligatorio-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_DB_DATABASE"></a> [DB\_DATABASE](#input\_DB\_DATABASE) | Variable para nombre de la base | `string` | n/a | yes |
| <a name="input_DB_PASSWORD"></a> [DB\_PASSWORD](#input\_DB\_PASSWORD) | Variable para Password RDS | `string` | n/a | yes |
| <a name="input_DB_USER"></a> [DB\_USER](#input\_DB\_USER) | Variable para usuario RDS | `string` | n/a | yes |
| <a name="input_instance_ami"></a> [instance\_ami](#input\_instance\_ami) | Variable para especificar la AMI | `string` | n/a | yes |
| <a name="input_instance_type_name"></a> [instance\_type\_name](#input\_instance\_type\_name) | Variable para especificar el tipo de instancia | `string` | n/a | yes |
| <a name="input_private_key_name"></a> [private\_key\_name](#input\_private\_key\_name) | Variable para especificar el nombre a private key, ej. private | `string` | n/a | yes |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Variable para especificar la ruta a la private key, ej. /home/private.pem | `string` | n/a | yes |
| <a name="input_private_subnet_a"></a> [private\_subnet\_a](#input\_private\_subnet\_a) | Variable para la subnet az-a | `string` | n/a | yes |
| <a name="input_private_subnet_b"></a> [private\_subnet\_b](#input\_private\_subnet\_b) | Variable para la subnet az-b | `string` | n/a | yes |
| <a name="input_retention_period"></a> [retention\_period](#input\_retention\_period) | Variable para especificar la cantidad de dias de retencion de los snapshot en RDS | `number` | n/a | yes |
| <a name="input_script_path"></a> [script\_path](#input\_script\_path) | Variable para especificar la ruta al script de backup, ej. /home/script.sh | `string` | n/a | yes |
| <a name="input_vpc_aws_az-a"></a> [vpc\_aws\_az-a](#input\_vpc\_aws\_az-a) | Variable para la zona az-a | `string` | n/a | yes |
| <a name="input_vpc_aws_az-b"></a> [vpc\_aws\_az-b](#input\_vpc\_aws\_az-b) | Variable para la zona az-b | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | Variable para el CIDR block | `string` | n/a | yes |
