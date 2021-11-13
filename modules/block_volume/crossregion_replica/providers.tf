#
# modules/block_volume/crossregion_replica/providers.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs
#

terraform {
  required_providers {      
    oci = {
      source = "hashicorp/oci"
    }
  }
}