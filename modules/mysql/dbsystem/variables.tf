#
# modules/mysql/dbsystem/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/mysql_mysql_db_system
#

variable "compartment_id" {
    description = "(Required) The OCID of the compartment."
    type = string    
}

variable "admin_username" {
    description = "(Required) The username for the administrative user."
    type = string
}

variable "admin_password" {
    description = "(Required) The password for the administrative user. The password must be between 8 and 32 characters long, and must contain at least 1 numeric character, 1 lowercase character, 1 uppercase character, and 1 special (nonalphanumeric) character."
    type = string
    sensitive = true
}

variable "ad_name" {
    description = "(Required) The availability domain on which to deploy the Read/Write endpoint. This defines the preferred primary instance. For a standalone DB System, this defines the availability domain in which the DB System is placed."
    type = string    
}

variable "backup_policy" {
    description = "(Optional) (Updatable) Backup policy as optionally used for DB System Creation."
    type = object({
        is_enable = bool
        retention_days = optional(string)
        window_start_time = optional(string)
    })

    default = {
        is_enable = false
    }
}

variable "config_id" {
    description = "(Optional) The OCID of the Configuration to be used for this DB System."
    type = string
}

variable "storage_gb" {
    description = "(Optional) Initial size of the database data volume in GBs that will be created and attached."
    type = number
    default = 100
}

variable "description" {
    description = "(Optional) (Updatable) User-provided data about the DB System."
    type = string
    default = "MySQL DB System"
}

variable "display_name" {
    description = "(Optional) (Updatable) The user-friendly name for the DB System. It does not have to be unique."
    type = string
    default = "mysql"
}

variable "fd_name" {
    description = "(Optional) The fault domain on which to deploy the Read/Write endpoint. This defines the preferred primary instance."
    type = string
    default = null
}

variable "hostname" {
    description = "(Optional) The hostname for the primary endpoint of the DB System. Used for DNS."
    type = string
    default = null
}

variable "ip_addr" {
    description = "(Optional) The IP address the DB System is configured to listen on."
    type = string
    default = null
}

variable "is_highly_available" {
    description = "(Optional) (Updatable) Specifies if the DB System is highly available."
    type = bool
    default = false
}

variable "maintenance_start_time" {
    description = "(Optional) (Updatable) The Maintenance Policy (2 hour maintenance window) for the DB System."
    type = string
    default = null
}

variable "port" {
    description = "(Optional) The port for primary endpoint of the DB System to listen on."
    type = string
    default = "3306"
}

variable "port_x" {
    description = "(Optional) The TCP network port on which X Plugin listens for connections."
    type = string
    default = "33306"
}

variable "shape" {
    description = "(Required) The name of the shape."
    type = string
}

variable "subnet_id" {
    description = "(Required) The OCID of the subnet the DB System is associated with."
    type = string
}

variable "state" {
    description = "(Optional) (Updatable) The target state for the DB System."
    type = string
    default = "ACTIVE"

    validation {
       condition = can(regex("^(ACTIVE|INACTIVE)$", var.state))
       error_message = "The state for the DB System must be: ACTIVE or INACTIVE."
    }
}