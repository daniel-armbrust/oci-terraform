#
# modules/networking/public_ip/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_public_ip
#

variable "compartment_id" {
    description = "(Required) (Updatable) The OCID of the compartment to contain the public IP."
    type = string    
}

variable "display_name" {
    description = "(Optional) (Updatable) A user-friendly name."
    type = string
    default = "pubip"
}

variable "private_ip_id" {
    description = "(Optional) (Updatable) The OCID of the private IP to assign the public IP to."
    type = string
    default = null 
}

variable "lifetime" {
    description = "Defines if the public IP is EPHEMERAL or RESERVED."
    type = string    

    validation {
       condition = can(regex("^(EPHEMERAL|RESERVED)$", var.lifetime))
       error_message = "The lifetime can be one of these values: EPHEMERAL or RESERVED."
    }   
}