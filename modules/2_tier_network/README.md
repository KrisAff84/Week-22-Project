# Description
This module creates a two tier VPC architecture. A VPC, along with 2 private subnets, and two public subnets will be created, with appropriate routing tables and gateways. A VPC CIDR can be provided to override the default. All other CIDRs will be automatically generated based on the VPC CIDR.  

# Resources Created
* VPC
* 2 Public Subnets
* 2 Private Subnets
* Public Route Table
* Private Route Table
* Internet Gateway
* NAT Gateway

# Required Variables
* region