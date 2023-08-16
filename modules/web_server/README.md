# Description:

By default this module produces a single EC2 instance with appropriate security groups set up for web HTTP and HTTPS access, using a single public subnet from the default availability zone. When VPC and subnet variables are specified, one instance per defined subnet will be created. Each instance will have the same security groups. By default they allow HTTP access on port 80 and HTTPS access on port 443. An SSH security group is also defined, and a variable must be set for "my_ip". 

# Resources Created

* EC2 instance(s) - Contains user data configured for installation of nginx on a debian based ami if no user_data_file variable is set.
* Security groups for web and SSH access. 
* If variables are provided for two or more subnets, a load balancer will be created with appropriate accompanying resources (listener, target group and target group attachments). If load balancer is deployed web access will only be allowed through load balancer. 

# Required Variables

* region
* ami
* key_name
* my_ip
