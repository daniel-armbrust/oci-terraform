#
# gru_mysql.tf
# https://docs.oracle.com/en-us/iaas/mysql-database/index.html
#

#-------------------
# MySQL DB System
#-------------------

module "gru_mysql-prd" {
    source = "../modules/mysql/dbsystem"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_mysql-prd"
    description = "GRU MySQL Production DB System"

    shape = local.mysql_shapes.vm_standard_E31
    config_id = local.gru_mysql_configs.ha_vm_standard_E31
    is_highly_available = true
    storage_gb = 100
    ad_name = local.ads.gru_ad1_name
    subnet_id = module.gru_subprv-database_vcn-prd.id
    hostname = "grumysqlprd"

    admin_username = "admin"
    admin_password = "@Sup3rS3cr3t0!"

    backup_policy = {
        is_enable = true
        retention_in_days = "7"
        window_start_time = "01:00-00:00"
    }

    maintenance_start_time = "sun 01:00"   
}
