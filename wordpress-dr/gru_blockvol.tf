#
# gru_blockvol.tf
# https://docs.oracle.com/en-us/iaas/Content/Block/home.htm
#

#-------------------
# Block Volume
#-------------------

module "gru_blkvol-wordpress-upload" {
    source = "../modules/block_volume/volume"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id    
    
    display_name = "gru_blkvol-wordpress-upload"
    ad_name = local.ads.gru_ad1_name

    replica_display_name = "gru_blkvol-wordpress-upload_crossreplica-vcp"
    replica_ad_name = local.ads.vcp_ad1_name

    size_gb = 100    
}

module "gru_blkvol-wordpress-upload_attach_primary" {
    source = "../modules/block_volume/attach"

    providers = {
       oci = oci.gru
    }

    display_name = "gru_blkvol-wordpress-upload_attach_primary"

    volume_id = module.gru_blkvol-wordpress-upload.id
    instance_id = module.gru_vmlnx-wordpress_primary.id
    is_shareable = true
}

module "gru_blkvol-wordpress-upload_attach_backup" {
    source = "../modules/block_volume/attach"

    providers = {
       oci = oci.gru
    }

    display_name = "gru_blkvol-wordpress-upload_attach_backup"

    volume_id = module.gru_blkvol-wordpress-upload.id
    instance_id = module.gru_vmlnx-wordpress_backup.id
    is_shareable = true
}

module "gru_blkvol-wordpress-upload_bkppol" {
    source = "../modules/block_volume/backup"
    
    providers = {
       oci = oci.gru
    }

    backup_policy_id = local.gru_backup_policies.bronze
    block_volume_id = module.gru_blkvol-wordpress-upload.id
}

