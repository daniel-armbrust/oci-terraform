#
# vcp_compute.tf
# https://docs.oracle.com/en-us/iaas/Content/Compute/home.htm
#

#-------------------
# Virtual Machine
#-------------------
module "vcp_vmlnx1_subprv-database_vcn-dr" {
    source = "./modules/compute"

    providers = {
       oci = oci.vcp
    }

     compartment_id = var.compartment_id
     display_name = "vcp_vmlnx1_subprv-database_vcn-dr"
     hostname = "vcpvmlnx1"

     subnet_id = module.vcp_subprv-database_vcn-dr.id
     ad_name = local.ads.vcp_ad1_name
     fd_name = local.fds.vcp_fd3_name

     shape = "VM.Standard2.1"
        
     image_id = local.compute_image_id.vcp.ol7

     ssh_public_keys = file("${path.root}/keys/common.ssh_pubkey")
}