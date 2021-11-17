#
# vcp_compute.tf
# https://docs.oracle.com/en-us/iaas/Content/Compute/home.htm
#

#-------------------
# Virtual Machine
#-------------------

module "vcp_vmlnx-wordpress_primary" {
    source = "../modules/compute"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_vmlnx-wordpress_primary"
    hostname = "vcpwrdpress-p"

    subnet_id = module.vcp_subprv-backend_vcn-dr.id
    ad_name = local.ads.vcp_ad1_name
    fd_name = local.fds.vcp_fd1_name

    shape = "VM.Standard.E2.1"        
    image_id = local.compute_image_id.vcp.ol7
    ssh_public_keys = file("${path.root}/keys/common.ssh_pubkey")

    enable_bastion_plugin = true
}

module "vcp_vmlnx-wordpress_backup" {    
    source = "../modules/compute"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_vmlnx-wordpress_backup"
    hostname = "vcpwrdpress-b"

    subnet_id = module.vcp_subprv-backend_vcn-dr.id
    ad_name = local.ads.vcp_ad1_name
    fd_name = local.fds.vcp_fd3_name

    shape = "VM.Standard.E2.1"        
    image_id = local.compute_image_id.vcp.ol7
    ssh_public_keys = file("${path.root}/keys/common.ssh_pubkey")

    enable_bastion_plugin = true
}