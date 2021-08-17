#
# gru_compute.tf
# https://docs.oracle.com/en-us/iaas/Content/Compute/home.htm
#

#-------------------
# Virtual Machine
#-------------------
module "gru_jumpserver_subpub-frontend_vcn-shared" {
    source = "./modules/compute"

    providers = {
       oci = oci.gru
    }

     compartment_id = var.compartment_id
     display_name = "gru_jumpserver_subpub-frontend_vcn-shared"
     hostname = "jumpserver"
     assign_public_ip = true

     subnet_id = module.gru_subpub-frontend_vcn-shared.id
     ad_name = local.ads.gru_ad1_name
     fd_name = local.fds.gru_fd2_name

     shape = "VM.Standard2.1"
        
     image_id = local.compute_image_id.gru.ol7

     ssh_public_keys = file("${path.root}/keys/common.ssh_pubkey")
}

module "gru_vmlnx1_subprv-database_vcn-prd" {
    source = "./modules/compute"

    providers = {
       oci = oci.gru
    }

     compartment_id = var.compartment_id
     display_name = "gru_vmlnx1_subprv-database_vcn-prd"
     hostname = "gruvmlnx1"

     subnet_id = module.gru_subprv-database_vcn-prd.id
     ad_name = local.ads.gru_ad1_name
     fd_name = local.fds.gru_fd2_name

     shape = "VM.Standard2.1"
        
     image_id = local.compute_image_id.gru.ol7

     ssh_public_keys = file("${path.root}/keys/common.ssh_pubkey")
}