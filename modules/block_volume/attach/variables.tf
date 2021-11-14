#
# modules/block_volume/attach/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_attachment
#

variable "display_name" {
    description = "(Optional) A user-friendly name of the Block Volume Attachment."
    type = string
    default = "blockvol_attch"
}

variable "attachment_type" {
    description = "(Required) The type of volume. The only supported values are iscsi and paravirtualized."
    type = string
    default = "iscsi"
   
    validation {
       condition = can(regex("^(iscsi|paravirtualized)$", var.attachment_type))
       error_message = "The attachment type must be: iscsi or paravirtualized."
    }
}

variable "volume_id" {
    description = "(Required) The OCID of the volume."
    type = string
}

variable "instance_id" {
    description = "(Required) The OCID of the instance."
    type = string
}

variable "device_name" {
    description = "(Optional) The device name."
    type = string
    default = ""
}

variable "is_read_only" {
    description = "(Optional) Whether the attachment was created in read-only mode."
    type = bool
    default = false
}

variable "is_shareable" {
    description = "(Optional) If an attachment is created in shareable mode, then other instances can attach the same volume."
    type = bool
    default = false
}