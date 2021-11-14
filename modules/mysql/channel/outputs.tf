#
# modules/mysql/channel/outputs.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/mysql_channel
#

output "id" {
    value = oci_mysql_channel.mysql_channel.id
}