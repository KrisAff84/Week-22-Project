module "web_server" {
  source = "./modules/web_server"

  region = "us-west-2"
  public_subnet_ids = {
    "public_subnet_1" = module.network.public_subnet1_id,
    "public_subnet_2" = module.network.public_subnet2_id
  }
  ami            = "ami-03f65b8614a860c29"
  instance_type  = "t2.micro"
  key_name       = "kriskey"
  user_data_file = "nginx_debian.sh"
  vpc_id         = module.network.vpc_id
  my_ip          = "24.162.52.74/32"
}
module "network" {
  source = "./modules/2_tier_network"

  region = "us-west-2"
}
module "database" {
  source = "./modules/rds_db"
  region = "us-west-2"
  vpc_id = module.network.vpc_id
  db_subnet_ids = [
    module.network.private_subnet1_id,
    module.network.private_subnet2_id
  ]
  username            = "kris"
  password            = var.secret_password
  db_access_source_sg = module.web_server.ssh_access_sg_id
}


output "server_availability_zones" {
  value = module.web_server.instance_azs
}
output "server_security_groups" {
  value = module.web_server.security_groups
}
output "server_public_ips" {
  value = module.web_server.public_ips
}
output "lb_dns" {
  value = module.web_server.lb_dns_name
}
output "instance_ids" {
  value = module.web_server.instance_ids
}
output "db_address" {
  value = module.database.db_address
}
output "db_arn" {
  value = module.database.db_arn
}
