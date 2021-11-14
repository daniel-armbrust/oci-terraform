#
# modules/bastion/bastion/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/bastion_bastion
#

output "id" {
    value = oci_bastion_bastion.bastion.id
}