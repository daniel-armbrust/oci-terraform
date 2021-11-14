#
# modules/block_volume/attach/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_attachment
#

output "id" {
    value = oci_core_volume_attachment.volume_attachment.id
}

output "iqn" {
    value = oci_core_volume_attachment.volume_attachment.iqn
}