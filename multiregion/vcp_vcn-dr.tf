#
# gru_vcn-dr.tf
#

#---------------------------
# DR
#---------------------------

#-------------------
# VCN
#-------------------
module "vcp_vcn-dr" {
    source = "./modules/networking/vcn"
   
    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_vcn-dr"
    cidr_blocks = ["172.16.0.0/16"]
    dns_label = "vcpvcndr"
    is_ipv6enabled = false
}

#-------------------
# Service Gateway
#-------------------
module "vcp_sgw_vcn-dr" {
    source = "./modules/networking/service_gateway"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_sgw_vcn-dr"
    vcn_id = module.vcp_vcn-dr.id
    service_id = local.vcp_all_oci_services
}

#-------------------
# DHCP Options
#-------------------
module "vcp_dhcp_vcn-dr" {
    source = "./modules/networking/dhcp_options"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_dhcp_vcn-dr"
    vcn_id = module.vcp_vcn-dr.id
}

#-------------------
# Route Tables
#-------------------
module "vcp_rtb_subprv-database_vcn-dr" {
    source = "./modules/networking/route_table"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_rtb_subprv-database_vcn-dr"
    vcn_id = module.vcp_vcn-dr.id

    route_rules = [
        {
          destination = local.vcp_oci_services_cidr_block
          destination_type = "SERVICE_CIDR_BLOCK"
          network_entity_id = module.vcp_sgw_vcn-dr.id
          description = "Route through Service Gateway"
        },
        {
           destination = "10.0.4.0/24"
           destination_type = "CIDR_BLOCK"
           network_entity_id = module.vcp_drg.id
           description = "Route to reach the PRIVATE PRODUCTION DATABASE subnet in GRU region."
        }
    ]
}

#-------------------
# Security Lists
#-------------------
module "vcp_secl_subprv-database_vcn-dr" {
    source = "./modules/networking/security_list"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_secl_subprv-database_vcn-dr"
    vcn_id = module.vcp_vcn-dr.id

    egress_security_rules = [
       {
           description      = "Allow access from OCI to ALL."
           destination      = local.anywhere
           destination_type = "CIDR_BLOCK"         
           protocol         = local.all_protocols,      
           stateless        = false           
       }
    ]

    ingress_security_rules = [
        {
           description  = "Allow access from Anywhere."
           source       = local.anywhere
           source_type  = "CIDR_BLOCK"           
           protocol     = local.all_protocols,
           stateless    = false                      
        }
    ]
}

#-------------------
# Subnets
#-------------------
module "vcp_subprv-database_vcn-dr" {
    source = "./modules/networking/subnet"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    vcn_id = module.vcp_vcn-dr.id
    dhcp_options_id = module.vcp_dhcp_vcn-dr.id
    route_table_id = module.vcp_rtb_subprv-database_vcn-dr.id
    security_list_ids = [module.vcp_secl_subprv-database_vcn-dr.id]

    display_name = "vcp_subprv-database_vcn-dr"
    dns_label = "subprvdbdr"
    cidr_block = "172.16.10.0/24"
    prohibit_public_ip_on_vnic = true
}