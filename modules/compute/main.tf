#
# modules/compute/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance
#

resource "oci_core_instance" "custom_shape_compute_instance" {
    count = var.gbs_memory != null && var.ocpus != null ? 1 : 0

    compartment_id = var.compartment_id
    availability_domain = var.ad_name
    fault_domain = var.fd_name
    
    display_name = var.display_name    

    shape = var.shape

    shape_config {
        baseline_ocpu_utilization = var.baseline_ocpu_utilization
        memory_in_gbs = var.gbs_memory
        ocpus = var.ocpus
    }

    create_vnic_details {
        display_name = var.vnic_display_name == "vnic" || var.vnic_display_name == "" ? "${var.vnic_display_name}-${var.display_name}" : var.vnic_display_name
        hostname_label = var.hostname

        subnet_id = var.subnet_id
        assign_public_ip = var.assign_public_ip
        skip_source_dest_check = var.skip_source_dest_check
    }

    source_details {
        source_id = var.image_id
        source_type = var.image_source_type
    }

    metadata = var.ssh_public_keys != null ? {"ssh_authorized_keys": var.ssh_public_keys} : {}
}

resource "oci_core_instance" "fixed_shape_compute_instance" {
    count = var.gbs_memory == null && var.ocpus == null ? 1 : 0

    compartment_id = var.compartment_id
    availability_domain = var.ad_name
    fault_domain = var.fd_name
    
    display_name = var.display_name    

    shape = var.shape

    create_vnic_details {
        display_name = var.vnic_display_name == "vnic" || var.vnic_display_name == "" ? "${var.vnic_display_name}-${var.display_name}" : var.vnic_display_name
        hostname_label = var.hostname

        subnet_id = var.subnet_id
        assign_public_ip = var.assign_public_ip
        skip_source_dest_check = var.skip_source_dest_check
    }

    source_details {
        source_id = var.image_id
        source_type = var.image_source_type
    }

    metadata = var.ssh_public_keys != null ? {"ssh_authorized_keys": var.ssh_public_keys} : {}
}