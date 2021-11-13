#
# modules/block_volume/crossregion_replica/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume
#

output "id" {
    value = oci_core_volume.block_volume.id
}