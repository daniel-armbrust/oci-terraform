#
# modules/file_storage/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/file_storage_file_system
#

resource "oci_file_storage_file_system" "file_system" {
    compartment_id = var.compartment_id
    availability_domain = var.ad_name

    display_name = var.fs_display_name   
    source_snapshot_id = var.source_snapshot_id
}

resource "oci_file_storage_mount_target" "mount_target" {
    compartment_id = var.compartment_id
    availability_domain = var.ad_name
    
    subnet_id = var.subnet_id
        
    display_name = var.mt_display_name
    
    hostname_label = var.hostname
    ip_address = var.ip_addr
    nsg_ids = var.nsg_ids
}

resource "oci_file_storage_export" "fss_export" {
    export_set_id = oci_file_storage_mount_target.mount_target.export_set_id
    file_system_id = oci_file_storage_file_system.file_system.file_system_id
    path = var.export_path

    export_options {
        source = var.allow_cidr_src
        access = var.export_access        
    }
}