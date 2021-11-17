#
# gru_mysql.tf
# https://docs.oracle.com/en-us/iaas/mysql-database/index.html
#

#-------------------
# MySQL DB System
#-------------------

module "mysql-prd" {
    source = "../modules/mysql/dbsystem"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "mysql-prd"
    description = "MySQL Production DB System"

    shape = local.mysql_shapes.vm_standard_E31
    config_id = local.gru_mysql_configs.standalone_vm_standard_E31
    is_highly_available = false
    storage_gb = 50
    ad_name = local.ads.gru_ad1_name
    subnet_id = module.subprv-database_vcn-prd.id
    hostname = "mysqlprd"

    admin_username = "admin"
    admin_password = "Sup3rS3cr3t0#"

    backup_policy = {
        is_enable = false      
    }

    maintenance_start_time = "sun 01:00"   
}