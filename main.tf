locals {
  region = "us-west-2"
  name_prefix = "tf-test"
}

module "web_server" {
  source = "./modules/web_server"

  region            = local.region
  name_prefix       = local.name_prefix
  ami               = "ami-03f65b8614a860c29"
  instance_type     = "t2.micro"
  # key_name          = "kriskey"
  user_data_file    = "nginx_debian.sh"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = [
    module.network.public_subnet1_id, 
    module.network.public_subnet2_id
  ]
  # my_ip             = "24.162.52.74/32"
}

module "network" {
  source = "./modules/2_tier_network"

  region = local.region
  name_prefix = local.name_prefix
}

module "database" {
  source = "./modules/rds_db"
  region = local.region
  name_prefix = local.name_prefix
  vpc_id = module.network.vpc_id
  db_subnet_ids = [
    module.network.private_subnet1_id,
    module.network.private_subnet2_id
  ]
  username            = "username"
  password            = var.secret_password
  db_access_source_sg = module.web_server.ssh_access_sg_id
}


output "server_availability_zones" {
  value = module.web_server.instance_azs
}
output "server_public_ips" {
  value = module.web_server.public_ips
}
output "lb_dns" {
  value = module.web_server.lb_dns_name
}
output "ami" {
  value = module.web_server.ami
}
output "db_address" {
  value = module.database.db_address
}
