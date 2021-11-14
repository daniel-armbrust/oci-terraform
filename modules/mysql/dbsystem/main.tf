#
# modules/mysql/dbsystem/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/mysql_mysql_db_system
#

terraform { 
  experiments = [module_variable_optional_attrs]
}

resource "oci_mysql_mysql_db_system" "mysql_dbsystem" {
    compartment_id = var.compartment_id

    display_name = var.display_name
    description = var.description

    shape_name = var.shape
    configuration_id = var.config_id
    is_highly_available = var.is_highly_available
    data_storage_size_in_gb = var.storage_gb

    availability_domain = var.ad_name
    fault_domain = var.fd_name
    subnet_id = var.subnet_id
    ip_address = var.ip_addr
    hostname_label = var.hostname
    port = var.port
    port_x = var.port_x

    admin_username = var.admin_username
    admin_password = var.admin_password        

    backup_policy {
        is_enabled = var.backup_policy.is_enable
        retention_in_days = var.backup_policy.retention_days
        window_start_time = var.backup_policy.window_start_time
    }

    maintenance {
        window_start_time = var.maintenance_start_time
    }
}