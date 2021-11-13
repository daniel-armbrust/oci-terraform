#
# modules/block_volume/volume/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume
#

variable "compartment_id" {
    description = "(Required) (Updatable) The OCID of the compartment that contains the block volume."
    type = string    
}

variable "display_name" {
    description = "(Optional) (Updatable) A user-friendly name for Block Volume."
    type = string
    default = "blockvol"
}

variable "replica_display_name" {
    description = "(Optional) (Updatable) A user-friendly name for Block Volume Replica."
    type = string
    default = null
}

variable "ad_name" {
    description = "The availability domain (ad) to create the block volume."
    type = string        
}

variable "replica_ad_name" {
    description = "(Optional) The availability domain (ad) to create the block volume Cross Region Replication."
    type = string    
    default = null
}

variable "replica_delete" {
    description = "Boolean value to control block volume replication deletion."
    type = bool
    default = true
}

variable "is_auto_tune_enabled" {
    description = "(Optional) (Updatable) Specifies whether the auto-tune performance is enabled for this block volume."
    type = bool
    default = false
}

variable "size_gb" {
    description = "(Optional) (Updatable) The size of the block volume in GBs."
    type = number
    default = 100
}

variable "vpus_per_gb" {
    description = "(Optional) (Updatable) The number of volume performance units (VPUs) that will be applied to this block volume per GB."
    type = number
    default = 10

    validation {
       condition = can(regex("^(0|10|20)$", var.vpus_per_gb))
       error_message = "The number of volume performance units (VPUs) must be: 0, 10 or 20."
    }
}