#
# modules/compute/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance
#

variable "compartment_id" {
    description = "(Required) (Updatable) The OCID of the compartment."
    type = string    
}

variable "display_name" {
    description = "(Optional) (Updatable) A user-friendly name."
    type = string
    default = "compute-instance"
}

variable "subnet_id" {
    description = "(Optional) The OCID of the subnet to create the VNIC in."
    type = string    
}

variable "vnic_display_name" {
    description = "(Optional) (Updatable) A user-friendly name for the VNIC."
    type = string
    default = "vnic"
}

variable "private_ip" {
    description = "(Optional) A private IP address of your choice to assign to the VNIC. "
    type = string
    default = null
}

variable "hostname" {
    description = "(Optional) (Updatable) The hostname for the VNIC's primary private IP. Used for DNS."
    type = string
    default = "compute-instance"
}

variable "assign_public_ip" {
    description = "(Optional) (Updatable) Whether the VNIC should be assigned a public IP address."
    type = bool
    default = false
}

variable "skip_source_dest_check" {
    description = "(Optional) (Updatable) Whether the source/destination check is disabled on the VNIC."
    type = bool
    default = false
}

variable "ad_name" {
    description = "(Required) The availability domain name of the vnic for the compute instance."
    type = string    
}

variable "fd_name" {
    description = "(Required) The fault domain name of the vnic for the compute instance."
    type = string
    default = null
}

variable "shape" {
    description = "(Required) (Updatable) The shape of an instance."
    type = string
    default = "VM.Standard.E2.1.Micro"
}

variable "baseline_ocpu_utilization" {
    description = "(Optional) (Updatable) The baseline OCPU utilization for a subcore burstable VM instance."
    type = string
    default = "BASELINE_1_1"
}

variable "gbs_memory" {
    description = "(Optional) (Updatable) The total amount of memory available to the instance, in gigabytes."
    type = string
    default = null
}

variable "ocpus" {
    description = "(Optional) (Updatable) The total number of OCPUs available to the instance."
    type = string
    default = null
}

variable "image_id" {
    description = "(Required) The OCID of an image to use."
    type = string
}

variable "image_source_type" {
    description = "The source type for the instance. Use image when specifying the image OCID. Use bootVolume when specifying the boot volume OCID."
    type = string
    default = "image"
}

variable "ssh_public_keys" {
    description = "Provide one or more public SSH keys to be included in the ~/.ssh/authorized_keys file for the default user on the instance. Use a newline character to separate multiple keys."
    type = string
    default = null
}

variable "enable_bastion_plugin" {
    description = "(Optional) (Updatable) Enable Bastion Pluging."
    type = bool
    default = false
}