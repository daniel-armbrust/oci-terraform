#
# modules/networking/security_list/output.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_security_list
#

output "id" {
    value = oci_core_security_list.security_list.id
}