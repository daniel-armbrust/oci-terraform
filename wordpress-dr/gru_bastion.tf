#
# gru_bastion.tf
# https://docs.oracle.com/en-us/iaas/Content/Bastion/home.htm
#

#-------------------
# Bastion
#-------------------

module "gru_bastion" {
    source = "../modules/bastion/bastion"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    name = "GruBastionWordpress"
    client_cidr_list = [""]
    target_subnet_id = module.gru_subprv-backend_vcn-prd.id
}
