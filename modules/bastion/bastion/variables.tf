#
# modules/bastion/bastion/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/bastion_bastion
#

variable "compartment_id" {
    description = "(Required) (Updatable) The unique identifier (OCID) of the compartment where the bastion is located."
    type = string    
}

variable "type" {
    description = "(Required) The type of bastion. Use standard."
    type = string
    default = "standard"
}

variable "client_cidr_list" {
    description = "(Optional) (Updatable) A list of address ranges in CIDR notation that you want to allow to connect to sessions hosted by this bastion."
    type = list(string)
}

variable "name" {
    description = "(Optional) The name of the bastion, which can't be changed after creation."
    type = string
    default = "Bastion"
}

variable "target_subnet_id" {
    description = "(Required) The unique identifier (OCID) of the subnet that the bastion connects to."
    type = string
}