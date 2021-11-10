#
# modules/networking/drg_route_table/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg_route_table
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg_route_table_route_rule
#

variable "display_name" {
    description = "(Optional) (Updatable) A user-friendly name."
    type = string
    default = "drg_route_table"
}

variable "drg_id" {
    description = "(Required) The OCID of the DRG the DRG route table belongs to."
    type = string
}

variable "is_ecmp_enabled" {
    description = "(Optional) (Updatable) If you want traffic to be routed using ECMP across your virtual circuits or IPSec tunnels to your on-premises networks, enable ECMP on the DRG route table."
    type = bool
    default = false
}

variable "route_rules" {
    description = "(Required) Route rules for DRG."

    type = list(object({
        destination = string
        nexthop_drg_attachment_id = string
    }))
}