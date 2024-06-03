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
  description = "Variable para especificar la cantidad de dias de retencion"
  
}