#
# modules/file_storage/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/file_storage_file_system
#

output "file_system_id" {
    value = oci_file_storage_file_system.file_system.id
}

output "mount_target_id" {
    value = oci_file_storage_mount_target.mount_target.id
}

output "export_set_id" {
    value = oci_file_storage_mount_target.mount_target.export_set_id
}