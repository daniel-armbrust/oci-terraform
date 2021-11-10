#
# modules/networking/drg/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg
#

variable "compartment_id" {
    description = "(Required) (Updatable) The OCID of the compartment to contain the DRG."
    type = string    
}

variable "display_name" {
    description = "(Optional) (Updatable) A user-friendly name."
    type = string
    default = "drg"
}