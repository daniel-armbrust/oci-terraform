#
# modules/file_storage/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/file_storage_file_system
#

variable "compartment_id" {
    description = "(Required) (Updatable) The OCID of the compartment to create the file system in."
    type = string    
}

variable "ad_name" {
    description = "(Required) The availability domain to create the file system in."
    type = string    
}

variable "fs_display_name" {
    description = "(Optional) (Updatable) A user-friendly name for File System."
    type = string
    default = "fss"
}

variable "mt_display_name" {
    description = "(Optional) (Updatable) A user-friendly name for Mount Target."
    type = string
    default = "fss-mt"
}

variable "source_snapshot_id" {
    description = "(Optional) The OCID of the snapshot used to create a cloned file system."
    type = string
    default = null
}

variable "subnet_id" {
    description = "(Required) The OCID of the subnet in which to create the mount target."
    type = string
}

variable "hostname" {
    description = "(Optional) The hostname for the mount target's IP address, used for DNS resolution."
    type = string
    default = "fss"
}

variable "nsg_ids" {
    description = "(Optional) (Updatable) A list of Network Security Group OCIDs associated with this mount target"
    type = list(string)
    default = null
}

variable "ip_addr" {
    description = "(Optional) A private IP address of your choice. Must be an available IP address within the subnet's CIDR."
    type = string
    default = null
}

variable "export_access" {
    description = "(Optional) (Updatable) Type of access to grant clients using the file system through this export."
    type = string
    default = "READ_ONLY"
    
    validation {
       condition = can(regex("^(READ_ONLY|READ_WRITE)$", var.export_access))
       error_message = "The export access must be: READ_ONLY or READ_WRITE"
    }
}

variable "allow_cidr_src" {
    description = "(Required) (Updatable) CIDR to allow clients to mount this file system. Must be a either single IPv4 address or single IPv4 CIDR block."
    type = string
}

variable "export_path" {
    description = "(Required) Path used to access the associated file system."
    type = string
    
    validation {
       condition = can(regex("^\/[a-z]+[a-z0-9]{0,254}$", var.export_path))
       error_message = "The export path must be a valid NFS path."
    }
}