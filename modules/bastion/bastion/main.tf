#
# modules/bastion/bastion/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/bastion_bastion
#

resource "oci_bastion_bastion" "bastion" {
    compartment_id = var.compartment_id
    name = var.name

    bastion_type = var.type
    client_cidr_block_allow_list = var.client_cidr_list
    target_subnet_id = var.target_subnet_id 
}