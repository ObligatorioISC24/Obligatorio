module "instancias" {
source = "./modules/instancias"
count = 1
instance_type  = "t2.medium"
instance_name = "Instancia1"

}