#
# modules/networking/public_ip/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_public_ip
#

output "id" {       
    value = oci_core_public_ip.public_ip.id
}

output "ip" {
    value = oci_core_public_ip.public_ip.ip_address
}

