#
# modules/networking/drg_route_table/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg_route_table
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg_route_table_route_rule
#

resource "oci_core_drg_route_table" "drg_route_table" {
    drg_id = var.drg_id
    display_name = var.display_name
    is_ecmp_enabled = var.is_ecmp_enabled
}

resource "oci_core_drg_route_table_route_rule" "drg_route_table_rule" {    
    count = length(var.route_rules) > 0 ? length(var.route_rules) : 0

    drg_route_table_id = oci_core_drg_route_table.drg_route_table.id        
    destination_type = "CIDR_BLOCK"
    destination = var.route_rules[count.index]["destination"]
    next_hop_drg_attachment_id = var.route_rules[count.index]["nexthop_drg_attachment_id"]
}