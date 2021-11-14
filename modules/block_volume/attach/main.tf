#
# modules/block_volume/attach/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_attachment
#

resource "oci_core_volume_attachment" "volume_attachment" {
    display_name = var.display_name

    attachment_type = var.attachment_type
    instance_id = var.instance_id
    volume_id = var.volume_id
    device = var.device_name
    is_read_only = var.is_read_only
    is_shareable = var.is_shareable
}