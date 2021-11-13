#
# modules/block_volume/backup/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume
#

output "id" {
    value = oci_core_volume_backup_policy_assignment.block_volume_backup_policy_assignment.id
}