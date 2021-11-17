#
# locals.tf
#

locals {    
   anywhere = "0.0.0.0/0" 
   all_protocols = "all"

   # IANA protocol numbers
   icmp_protocol = 1
   tcp_protocol = 6
   udp_protocol = 17
   
   # Service Gateway
   gru_all_oci_services = lookup(data.oci_core_services.gru_all_oci_services.services[0], "id")
   gru_oci_services_cidr_block = lookup(data.oci_core_services.gru_all_oci_services.services[0], "cidr_block")   

   # Region Names
   # See: https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm
   region_names = {
      "gru" = "sa-saopaulo-1"      
   }

   # Availability Domains
   ads = {
      gru_ad1_id = data.oci_identity_availability_domains.gru_ads.availability_domains[0].id
      gru_ad1_name = data.oci_identity_availability_domains.gru_ads.availability_domains[0].name
   }
 
   # Fault Domains
   fds = {
      gru_fd1_id = data.oci_identity_fault_domains.gru_fds.fault_domains[0].id,
      gru_fd1_name = data.oci_identity_fault_domains.gru_fds.fault_domains[0].name,

      gru_fd2_id = data.oci_identity_fault_domains.gru_fds.fault_domains[1].id,
      gru_fd2_name = data.oci_identity_fault_domains.gru_fds.fault_domains[1].name,

      gru_fd3_id = data.oci_identity_fault_domains.gru_fds.fault_domains[2].id,
      gru_fd3_name = data.oci_identity_fault_domains.gru_fds.fault_domains[2].name     
   }

   # Backup Policies
   gru_backup_policies = {   
      bronze = data.oci_core_volume_backup_policies.gru_bronze_backup_policy.volume_backup_policies[0].id
      silver = data.oci_core_volume_backup_policies.gru_silver_backup_policy.volume_backup_policies[0].id
      gold = data.oci_core_volume_backup_policies.gru_gold_backup_policy.volume_backup_policies[0].id
   }

   # MySQL Configurations
   gru_mysql_configs = {      
      standalone_vm_standard_E21 = data.oci_mysql_mysql_configurations.gru_mysqlconfig_standalone_vm_standard-E21.configurations[0].id
      standalone_vm_standard_E22 = data.oci_mysql_mysql_configurations.gru_mysqlconfig_standalone_vm_standard-E22.configurations[0].id
      standalone_vm_standard_E31 = data.oci_mysql_mysql_configurations.gru_mysqlconfig_standalone_vm_standard-E31.configurations[0].id
      ha_vm_standard_E31 = data.oci_mysql_mysql_configurations.gru_mysqlconfig_ha_vm_standard-E31.configurations[0].id
   }

   # MySQL Shapes
   mysql_shapes = {
      vm_standard_E21 = data.oci_mysql_shapes.mysql_shape_vm_standard-E21.shapes[0].name
      vm_standard_E22 = data.oci_mysql_shapes.mysql_shape_vm_standard-E22.shapes[0].name
      vm_standard_E31 = data.oci_mysql_shapes.mysql_shape_vm_standard-E31.shapes[0].name
   }

   #
   # See: https://docs.oracle.com/en-us/iaas/images/
   #
   compute_image_id = {
      "gru" = {
         "centos7" = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaarihpw2lfked2jfoigpma3e7dkt36gw6yg26ceh6zup4jvthj7jkq",
         "centos8" = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaji7374dd3t5rjllcvskopfydco24lf2c62jitixxdxwncdlanfvq",
         "ol7" = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa4vkhemdkmfe3icxzzdkgfnfijybzzhrz63icerlq7oyzdoe3mv6a",
         "ol8" = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaacsn7itsqbert6n7g4ywxrhmyrocfigqi5jmrhfwfxl4rlvjz2fyq"
      }
   }
}