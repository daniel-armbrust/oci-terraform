#
# modules/block_volume/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume
#

variable "compartment_id" {
    description = "(Required) (Updatable) The OCID of the compartment that contains the volume."
    type = string    
}

variable "display_name" {
    description = "(Optional) (Updatable) A user-friendly name."
    type = string
    default = "blockvol"
}

variable "ad_name" {
    description = "(Optional) The availability domain of the volume. Omissible for cloning a volume."
    type = string    
    default = null
}

variable "is_auto_tune_enabled" {
    description = "(Optional) (Updatable) Specifies whether the auto-tune performance is enabled for this volume."
    type = bool
    default = false
}

variable "size_in_gbs" {
    description = "(Optional) (Updatable) The size of the volume in GBs."
    type = number
    default = 100
}

variable "vpus_per_gb" {
    description = "(Optional) (Updatable) The number of volume performance units (VPUs) that will be applied to this volume per GB."
    type = number
    default = 10
}

