#
# modules/compute/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance
#

output "id" {
    value = join("", oci_core_instance.custom_shape_compute_instance.*.id, oci_core_instance.custom_shape_compute_instance_bastion-plugin.*.id, oci_core_instance.fixed_shape_compute_instance_bastion-plugin.*.id, oci_core_instance.fixed_shape_compute_instance.*.id)
}

output "private_ip" {
    value = join("", oci_core_instance.custom_shape_compute_instance.*.private_ip, oci_core_instance.custom_shape_compute_instance_bastion-plugin.*.private_ip, oci_core_instance.fixed_shape_compute_instance_bastion-plugin.*.private_ip, oci_core_instance.fixed_shape_compute_instance.*.private_ip)
}