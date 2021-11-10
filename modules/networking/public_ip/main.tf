#
# modules/networking/public_ip/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_public_ip
#

resource "oci_core_public_ip" "public_ip" {
    compartment_id = var.compartment_id  
    display_name = var.display_name
    lifetime = var.lifetime
    private_ip_id = var.private_ip_id   
}
