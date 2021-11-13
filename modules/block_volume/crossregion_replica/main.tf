#
# modules/block_volume/crossregion_replica/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume
#

resource "oci_core_volume" "block_volume" {
   compartment_id = var.compartment_id
   
   display_name = var.display_name

   availability_domain = var.ad_name
   size_in_gbs = var.size_gb
   vpus_per_gb = var.vpus_per_gb
   is_auto_tune_enabled = var.is_auto_tune_enabled      

   source_details {
      id = var.replica_src_id
      type = "blockVolumeReplica"
   }
   
   block_volume_replicas_deletion = var.replica_delete
}
