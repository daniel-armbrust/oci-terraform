#
# modules/networking/drg_route_table/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg_route_table
#

output "id" {
    value = oci_core_drg_route_table.drg_route_table.id
}