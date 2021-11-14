#
# modules/mysql/channel/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/mysql_mysql_db_system
#

variable "compartment_id" {
    description = "(Optional) The OCID of the compartment."
    type = string    
}

variable "description" {
    description = "(Optional) (Updatable) User provided information about the Channel."
    type = string
    default = "MySQL Channel"
}

variable "display_name" {
    description = "(Optional) (Updatable) The user-friendly name for the Channel. It does not have to be unique."
    type = string
    default = "mysql_channel"
}

variable "is_enabled" {
    description = "(Optional) (Updatable) Whether the Channel should be enabled upon creation."
    type = bool
    default = true
}

variable "source_mysql" {
   description = "(Required) (Updatable) The MySQL Channel Source."
   type = object({
       hostname = string
       username = string
       password = string
       port = optional(string)
       source_type = string
   })
}

variable "target_mysql" {
    description = "(Required) (Updatable) The MySQL Channel Target."
    type = object({
        username = string
        channel_name = string
        db_system_id = string
        target_type = string
    })
}