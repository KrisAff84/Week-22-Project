# Description 
This module creates an RDS database with a MYSQL v 8.0.33 engine by default, along with the accompanying security group to allow database access. Many options are available so please check out the variables file to see what is possible. 

# Required Variables
* region
* vpc_id
* db_subnet_ids (list)
* username 
* password
* db_access_source_sg (security group of source to allow db access to)