#
# modules/networking/drg_attachment/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg_attachment
#

resource "oci_core_drg_attachment" "drg_attachment" {
    display_name = var.display_name
    drg_id = var.drg_id

    network_details {
        id = var.network_id
        type = var.network_type
    }
}