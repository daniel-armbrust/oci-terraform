#
# modules/block_volume/backup/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume
#

variable "backup_policy_id" {
    description = "(Required) The OCID of the volume backup policy to assign to the block volume."
    type = string
}

variable "block_volume_id" {
    description = "(Required) The OCID of the block volume to assign the policy to."
    type = string
}