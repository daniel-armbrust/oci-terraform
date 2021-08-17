#
# modules/networking/drg_remote_peering/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_remote_peering_connection
#

resource "oci_core_remote_peering_connection" "drg_rpc" {  
    compartment_id = var.compartment_id
    drg_id = var.drg_id    
    peer_id = var.peer_id
    peer_region_name = var.region_name
    display_name = var.display_name    
}