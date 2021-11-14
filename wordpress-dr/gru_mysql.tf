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
    config_id = local.gru_mysql_configs.standalone_vm_standard_E31
    is_highly_available = false
    storage_gb = 100
    ad_name = local.ads.gru_ad1_name
    subnet_id = module.gru_subprv-database_vcn-prd.id
    hostname = "grumysqlprd"

    admin_username = "admin"
    admin_password = "Sup3rS3cr3t0#"

    backup_policy = {
        is_enable = true
        retention_in_days = "7"
        window_start_time = "01:00-00:00"
    }

    maintenance_start_time = "sun 01:00"   
}

module "gru_mysql-channel-prd" {
    source = "../modules/mysql/channel"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_mysql-channel-prd"
    description = "GRU MySQL Production Channel DB System"

    mysql_source = {
        hostname = module.gru_mysql-prd.hostname
        username = "rpluser001"
        password = "Sup3rS3cr3t0#"
        type = "MYSQL"
        ssl_mode = "DISABLED"
    }

    mysql_target = {
        username = "admin"
        channel_name = "replication_channel"
        db_system_id = module.gru_mysql-prd.id
        type = "DBSYSTEM"
    }
}