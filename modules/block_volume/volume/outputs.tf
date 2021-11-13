#
# modules/block_volume/volume/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume
#

output "id" {    
    value = join("", oci_core_volume.block_volume.*.id, oci_core_volume.block_volume_replica.*.id)
}

output "replica_id" {
    value = oci_core_volume.block_volume_replica[0].block_volume_replicas[0].block_volume_replica_id    
}