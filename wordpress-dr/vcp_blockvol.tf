#
# vcp_blockvol.tf
# https://docs.oracle.com/en-us/iaas/Content/Block/home.htm
#

#-------------------
# Block Volume
#-------------------

module "vcp_blkvol-wordpress-upload" {
    source = "../modules/block_volume/crossregion_replica"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id    
    
    display_name = "vcp_blkvol-wordpress-upload"
    ad_name = local.ads.vcp_ad1_name

    replica_src_id = module.gru_blkvol-wordpress-upload.replica_id

    size_gb = 100    
}

module "vcp_blkvol-wordpress-upload_bkppol" {
    source = "../modules/block_volume/backup"
    
    providers = {
       oci = oci.vcp
    }

    backup_policy_id = local.vcp_backup_policies.bronze
    block_volume_id = module.vcp_blkvol-wordpress-upload.id
}