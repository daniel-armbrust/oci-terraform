#
# modules/networking/drg_attachment/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg_attachment
#

variable "display_name" {
    description = "(Optional) (Updatable) A user-friendly name."
    type = string
    default = "drg_attachment"
}

variable "drg_id" {
    description = "(Required) The OCID of the DRG."
    type = string
}

variable "network_id" {
    description = "(Required) The OCID of the network attached to the DRG."
    type = string
}

variable "network_type" {
    description = "(Required) (Updatable) The type can be one of these values: IPSEC_TUNNEL, REMOTE_PEERING_CONNECTION, VCN, VIRTUAL_CIRCUIT."
    type = string
    
    validation {
       condition = can(regex("^(IPSEC_TUNNEL|REMOTE_PEERING_CONNECTION|VCN|VIRTUAL_CIRCUIT)$", var.network_type))
       error_message = "The network_type can be one of these values: IPSEC_TUNNEL, REMOTE_PEERING_CONNECTION, VCN, VIRTUAL_CIRCUIT."
    }   
}

