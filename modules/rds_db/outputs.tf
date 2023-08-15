#######################################
# Database
#######################################

output "db_address" {
  description = "The address of the RDS instance"
  value = aws_db_instance.default.address
}
output "db_az" {
  description = "The availability zone of the RDS instance"
  value = aws_db_instance.default.availability_zone
}
output "db_arn" {
  description = "The ARN of the RDS instance"
  value = aws_db_instance.default.arn
}
output "db_port" {
  description = "The port in which the database accepts connections"
  value = aws_db_instance.default.port
}
output "db_username" {
  description = "The username for the database"
  value = aws_db_instance.default.username
}
output "db_password" {
  description = "The password for the database"
  value = aws_db_instance.default.password
  sensitive = true
}
output "db_resource_id" {
  description = "The RDS Resource ID of this instance"
  value = aws_db_instance.default.resource_id
}
output "db_instance_name" {
  description = "The database instance name"
  value = aws_db_instance.default.identifier
}

#######################################
# Database Subnet Group
#######################################

output "db_subnet_group_name" {
  description = "The name of the database subnet group"
  value = aws_db_subnet_group.default.name
}
output "db_subnet_group_arn" {
  description = "The ARN of the database subnet group"
  value = aws_db_subnet_group.default.arn
}
output "db_subnet_group_vpc_id" {
  description = "The VPC ID of the database subnet group"
  value = aws_db_subnet_group.default.vpc_id
}
output "db_subnet_group_subnet_ids" {
  description = "The subnet IDs of the database subnet group"
  value = aws_db_subnet_group.default.subnet_ids
}

#######################################
# Database Security Group
#######################################

output "db_security_group_id" {
  value = aws_security_group.db_access.id
}