#################################
# Global
#################################

variable "region" {
  description = "The region to deploy to"
  type        = string
}
variable "vpc_id" {
  description = "The VPC ID to deploy to"
  type        = string
}
variable "name_prefix" {
  description = "The prefix to use for all resource names"
  type        = string
  default     = "tf-test"
}

#################################
# RDS Database
#################################

variable "db_subnet_ids" {
  description = "The subnet IDs to deploy the database subnet group to"
  type        = list(string)
}
variable "storage" {
  description = "The amount of storage to allocate to the database"
  type        = number
  default     = 20
}
variable "apply_immediately" {
  description = "Whether to apply changes immediately or wait for the next maintenance window"
  type        = bool
  default     = false
}
variable "minor_version_upgrade" {
  description = "Whether to automatically upgrade to minor versions"
  type        = bool
  default     = true
}
variable "backup_retention" {
  description = "The number of days to retain backups for"
  type        = number
  default     = 0
}
variable "blue_green_update_enabled" {
  description = "Whether to enable blue/green updates"
  type        = bool
  default     = true
}
variable "del_auto_backups" {
  description = "Whether to delete automated backups when the database is deleted"
  type        = bool
  default     = true
}
variable "deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = false
}
variable "cw_logs_exports" {
  description = "The list of log types to export to CloudWatch"
  type        = list(string)
  default     = null
}
variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}
variable "engine_version" {
  description = "The database engine version to use"
  type        = string
  default     = "8.0.33"
}
variable "multi_az" {
  description = "Whether to deploy the database in multiple availability zones"
  type        = bool
  default     = false
}
variable "instance_class" {
  description = "The instance class to use"
  type        = string
  default     = "db.t2.micro"
}
variable "username" {
  description = "The username to use for the database"
  type        = string
}
variable "password" {
  description = "The password to use for the database"
  type        = string
  sensitive   = true
}
variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when the database is deleted"
  type        = bool
  default     = true
}
variable "final_snapshot_name" {
  description = "Required if skip_final_snapshot is false. The name of the final snapshot to create"
  type        = string
  default     = null
}
variable "max_storage" {
  description = "Max storage to autoscale to. By default autoscaling is disabled"
  type        = number
  default     = 0
}
variable "open_port" {
    description = "The port in which the database accepts connections"
    type        = number
    default     = 3306
}
variable "publicly_accessible" {
    description = "Whether the database is publicly accessible"
    type        = bool
    default     = false
}
variable "encrypted" {
    description = "Whether the database is encrypted. Note that t2.micro does not support encryption"
    type        = bool
    default     = false
}

#################################
# Security Group
#################################

variable "db_access_sg_description" {
  description = "The description for the database access security group"
  type        = string
  default     = "Allow database access"
}

# To change the desired port use "open_port" above

variable "db_protocol" {
  description = "The protocol for the database access security group"
  type        = string
  default     = "tcp"
}
variable "db_access_source_sg" {
  description = "The source security group for the database access security group"
  type        = string
}
