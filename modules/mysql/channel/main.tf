#
# modules/mysql/channel/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/mysql_channel
#

terraform { 
  experiments = [module_variable_optional_attrs]
}

resource "oci_mysql_channel" "mysql_channel" {
   compartment_id = var.compartment_id

   display_name = var.display_name
   description = var.description
   is_enabled = var.is_enabled

   source {
       source_type = var.mysql_source.type
       hostname = var.mysql_source.hostname
       port = var.mysql_source.port
       username = var.mysql_source.username
       password = var.mysql_source.password
       ssl_mode = var.mysql_source.ssl_mode
   }

   target {
       db_system_id = var.mysql_target.db_system_id
       target_type = var.mysql_target.type
       applier_username = var.mysql_target.username
       channel_name = var.mysql_target.channel_name
   }
}