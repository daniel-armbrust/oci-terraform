#
# modules/networking/drg_attachment/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg_attachment
#

output "id" {
    value = oci_core_drg_attachment.drg_attachment.id
}
