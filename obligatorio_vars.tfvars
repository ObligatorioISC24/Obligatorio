#archivo para cargar valores de variales, se referencia con terraform plan/apply -var-file archivo

vpc_cidr         = "10.0.0.0/16"
private_subnet_a = "10.0.1.0/24"
private_subnet_b = "10.0.2.0/24"
vpc_aws_az-a     = "us-east-1a"
vpc_aws_az-b     = "us-east-1b"
DB_DATABASE      = "idukan"
DB_USER          = "root"
retention_period = 7