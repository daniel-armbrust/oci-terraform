#
# gru_compute.tf
# https://docs.oracle.com/en-us/iaas/Content/Compute/home.htm
#

#-------------------
# Virtual Machine
#-------------------

module "vmlnx-wordpress" {
    source = "../modules/compute"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "vmlnx-wordpress"
    hostname = "wordpress-p"

    subnet_id = module.subprv-backend_vcn-prd.id
    ad_name = local.ads.gru_ad1_name
    fd_name = local.fds.gru_fd1_name

    shape = "VM.Standard.E2.1"        
    image_id = local.compute_image_id.gru.ol7
    ssh_public_keys = file("${path.root}/keys/common.ssh_pubkey")

    enable_bastion_plugin = true
}