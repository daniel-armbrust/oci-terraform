#
# modules/block_volume/volume/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume
#

resource "oci_core_volume" "block_volume" {    
    count = var.replica_ad_name == null ? 1 : 0

    compartment_id = var.compartment_id
        
    display_name = var.display_name

    availability_domain = var.ad_name
    size_in_gbs = var.size_gb
    vpus_per_gb = var.vpus_per_gb
    is_auto_tune_enabled = var.is_auto_tune_enabled      
}

resource "oci_core_volume" "block_volume_replica" {    
    count = var.replica_ad_name != null ? 1 : 0

    compartment_id = var.compartment_id
        
    display_name = var.display_name

    availability_domain = var.ad_name
    size_in_gbs = var.size_gb
    vpus_per_gb = var.vpus_per_gb
    is_auto_tune_enabled = var.is_auto_tune_enabled    

    block_volume_replicas {
        display_name = var.replica_display_name
        availability_domain = var.replica_ad_name
    }

    block_volume_replicas_deletion = var.replica_delete
}