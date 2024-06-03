#CREACION VPC
resource "aws_vpc" "obligatorio-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc_obligatorio"
  }
}
#CREACION SUBNET
resource "aws_subnet" "obligatorio-tf-subnet-a" {
  vpc_id                  = aws_vpc.obligatorio-vpc.id
  cidr_block              = var.private_subnet_a
  availability_zone       = var.vpc_aws_az-a
  map_public_ip_on_launch = "true"
  tags = {
    Name = "obligatorio-tf-subnet-a"
  }
}

resource "aws_subnet" "obligatorio-tf-subnet-b" {
  vpc_id                  = aws_vpc.obligatorio-vpc.id
  cidr_block              = var.private_subnet_b
  availability_zone       = var.vpc_aws_az-b
  map_public_ip_on_launch = "true"
  tags = {
    Name = "obligatorio-tf-subnet-b"
  }
}

##Creacion de grupo para utilizar en RDS

resource "aws_db_subnet_group" "network-group-obligatorio" {

  name = "network-group-obligatorio"

  subnet_ids = [aws_subnet.obligatorio-tf-subnet-a.id, aws_subnet.obligatorio-tf-subnet-b.id]

  tags = {

    Name = "network-group-obligatorio"

  }

}

#CREACION INTERNET GATEWAY
resource "aws_internet_gateway" "obligatorio-ig" {
  vpc_id = aws_vpc.obligatorio-vpc.id
  tags = {
    Name = "obligatorio-tf-ig"
  }
}
#CREACION ROUTE TABLE
resource "aws_route_table" "obligatorio-rt" {

  vpc_id = aws_vpc.obligatorio-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.obligatorio-ig.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.obligatorio-ig.id
  }
  tags = {
    Name = "obligatorio-rt"
  }
}

#Asociar las redes a la rtb
resource "aws_route_table_association" "subneta" {
  subnet_id      = aws_subnet.obligatorio-tf-subnet-a.id
  route_table_id = aws_route_table.obligatorio-rt.id
}

resource "aws_route_table_association" "subnetb" {
  subnet_id      = aws_subnet.obligatorio-tf-subnet-b.id
  route_table_id = aws_route_table.obligatorio-rt.id
}

#Creacion SG para intancias

resource "aws_security_group" "obligatorio-sg" {
  name   = "obligatorio-sg"
  vpc_id = aws_vpc.obligatorio-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Creacion SG para RDS

resource "aws_security_group" "obligatorio-sg-RDS" {
  name   = "obligatorio-sg-RDS"
  vpc_id = aws_vpc.obligatorio-vpc.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

}

#Creacion SG para EFS

resource "aws_security_group" "obligatorio-sg-EFS" {
  name   = "obligatorio-sg-EFS"
  vpc_id = aws_vpc.obligatorio-vpc.id
  # Regla para TCP en el puerto 2049
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Regla para UDP en el puerto 2049
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Regla para TCP en el puerto 111
  ingress {
    from_port   = 111
    to_port     = 111
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Regla para UDP en el puerto 111
  ingress {
    from_port   = 111
    to_port     = 111
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/16"]
  }


}