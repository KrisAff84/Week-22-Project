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

# Special Considerations 
If you are specifying subnets to deploy instances to, the subnet variables must be provided as a map. The key does not matter, but the value must be the subnet ID. 
    e.g. 

    public_subnet_ids = {
        "subnet_1" = "subnet-0f14eefd953aa0a59",
        "subnet_2" = "subnet-0ce005b7cd036d206"
    }

   or if you are using a network module then you need to provide module output(s) that specify the desired subnet ID(s). 

    public_subnet_ids = {
        "subnet_1" = module.network_module.subnet_id_1,
        "subnet_2" = module.network_module.subnet_id_2
    }

   In the above examples the keys "subnet_1" and "subnet_2" do not matter. What's important is that the values are subnet IDs and the map format is correct. 

