#
# modules/block_volume/backup/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume
#

resource "oci_core_volume_backup_policy_assignment" "block_volume_backup_policy_assignment" {    
    policy_id = var.backup_policy_id
    asset_id = var.block_volume_id
}