# VARIABLES Networking
variable "vpc_cidr" {
  type        = string
  description = "Variable para el CIDR block"
}
variable "private_subnet_a" {
  type        = string
  description = "Variable para la subnet az-a"
}

variable "private_subnet_b" {
  type        = string
  description = "Variable para la subnet az-b"
}

variable "vpc_aws_az-a" {
  type        = string
  description = "Variable para la zona az-a"
}

variable "vpc_aws_az-b" {
  type        = string
  description = "Variable para la zona az-b"
}

variable "DB_USER" {
  type        = string
  description = "Variable para usuario RDS"
}

variable "DB_PASSWORD" {
  type        = string
  description = "Variable para Password RDS"
}

variable "DB_DATABASE" {
  type        = string
  description = "Variable para nombre de la base"
}

variable "retention_period" {
  type        = number
  description = "Variable para especificar la cantidad de dias de retencion de los snapshot en RDS"
  
}

variable "private_key_name" {
  type        = string
  description = "Variable para especificar el nombre a private key, ej. private"
  
}

variable "private_key_path" {
  type        = string
  description = "Variable para especificar la ruta a la private key, ej. /home/private.pem"
  
}

variable "instance_type_name" {
  type        = string
  description = "Variable para especificar el tipo de instancia"
  
}

variable "instance_ami" {
  type        = string
  description = "Variable para especificar la AMI"
  
}