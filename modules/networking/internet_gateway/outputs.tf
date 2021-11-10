#
# modules/networking/internet_gateway/output.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_internet_gateway
#

output "id" {
    value = oci_core_internet_gateway.internet_gateway.id
}
