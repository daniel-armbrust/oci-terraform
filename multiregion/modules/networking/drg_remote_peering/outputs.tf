#
# modules/networking/drg_remote_peering/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_remote_peering_connection
#

output "id" {  
    value = oci_core_remote_peering_connection.drg_rpc.id
}