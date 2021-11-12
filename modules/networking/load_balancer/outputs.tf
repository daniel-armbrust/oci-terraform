#
# modules/networking/load_balancer/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_load_balancer
#

output "load_balancer_id" {
    value = oci_load_balancer_load_balancer.load_balancer.id
}