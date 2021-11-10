#
# modules/networking/drg_remote_peering/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_remote_peering_connection
#

variable "compartment_id" {
    description = "(Required) (Updatable) The OCID of the compartment to contain the RPC."
    type = string    
}

variable "display_name" {
    description = "(Optional) (Updatable) A user-friendly name."
    type = string
    default = "rpc"
}

variable "drg_id" {
    description = "(Required) The OCID of the DRG the RPC belongs to."
    type = string
}

variable "peer_id" {
    description = "(Optional) The OCID of the RPC you want to peer with."
    type = string
    default = null
}

variable "region_name" {
    description = "(Optional) The name of the region that contains the RPC you want to peer with."
    type = string
    default = null
}