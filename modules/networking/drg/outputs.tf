#
# modules/networking/drg/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg
#

output "id" {
    value = oci_core_drg.drg.id
}