#
# public_ip.tf
# https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingpublicIPs.htm
#

module "gru_lb-wordpress_pubip" {
    source = "../modules/networking/public_ip"
   
    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_lb-wordpress_pubip"
    lifetime = "RESERVED"  
}

module "vcp_lb-wordpress_pubip" {
    source = "../modules/networking/public_ip"
   
    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "gru_lb-wordpress_pubip"
    lifetime = "RESERVED"  
}