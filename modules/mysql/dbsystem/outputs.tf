#
# modules/mysql/dbsystem/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/mysql_mysql_db_system
#

output "id" {
    value = oci_mysql_mysql_db_system.mysql_dbsystem.id
}

output "ip_addr" {
    value = oci_mysql_mysql_db_system.mysql_dbsystem.ip_address
}

output "port" {
    value = oci_mysql_mysql_db_system.mysql_dbsystem.port
}

output "hostname" {
    value = oci_mysql_mysql_db_system.mysql_dbsystem.hostname_label
}