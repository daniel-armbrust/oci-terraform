#
# modules/networking/drg/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg
#

resource "oci_core_drg" "drg" {  
    compartment_id = var.compartment_id
    display_name = var.display_name    
}