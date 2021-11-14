#
# vcp_mysql.tf
# https://docs.oracle.com/en-us/iaas/mysql-database/index.html
#

#-------------------
# MySQL DB System
#-------------------

module "vcp_mysql-dr" {
    source = "../modules/mysql/dbsystem"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_mysql-dr"
    description = "VCP MySQL DR DB System"

    shape = local.mysql_shapes.vm_standard_E31
    config_id = local.vcp_mysql_configs.standalone_vm_standard_E31
    is_highly_available = false
    storage_gb = 100
    ad_name = local.ads.vcp_ad1_name
    subnet_id = module.vcp_subprv-database_vcn-dr.id
    hostname = "vcpmysqldr"

    admin_username = "admin"
    admin_password = "Sup3rS3cr3t0#"

    backup_policy = {
        is_enable = true
        retention_in_days = "7"
        window_start_time = "01:00-00:00"
    }

    maintenance_start_time = "sun 01:00"   
}
