#
# gru_vcn-dev.tf
#

#---------------------------
# DEVELOPMENT
#---------------------------

#-------------------
# VCN
#-------------------
module "gru_vcn-dev" {
    source = "./modules/networking/vcn"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_vcn-dev"
    cidr_blocks = ["10.4.0.0/16"]
    dns_label = "gruvcndev"
    is_ipv6enabled = false
}

#-------------------
# NAT Gateway
#-------------------
module "gru_ngw_vcn-dev" {
    source = "./modules/networking/nat_gateway"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_ngw_vcn-dev"
    vcn_id = module.gru_vcn-dev.id
}

#-------------------
# Service Gateway
#-------------------
module "gru_sgw_vcn-dev" {
    source = "./modules/networking/service_gateway"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_sgw_vcn-dev"
    vcn_id = module.gru_vcn-dev.id
    service_id = local.gru_all_oci_services
}

#-------------------
# DHCP Options
#-------------------
module "gru_dhcp_vcn-dev" {
    source = "./modules/networking/dhcp_options"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_dhcp_vcn-dev"
    vcn_id = module.gru_vcn-dev.id
}

#-------------------
# Route Tables
#-------------------
module "gru_rtb_subprv-backend_vcn-dev" {
    source = "./modules/networking/route_table"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    display_name = "gru_rtb_subprv-backend_vcn-dev"
    vcn_id = module.gru_vcn-dev.id

    route_rules = [
        {
          destination = local.anywhere
          destination_type = "CIDR_BLOCK"
          network_entity_id = module.gru_ngw_vcn-dev.id
          description = "Route through NAT Gateway"
        },
        {
           destination = "10.6.0.0/26"
           destination_type = "CIDR_BLOCK"
           network_entity_id = module.gru_drg.id
           description = "Route to reach PUBLIC PRODUCTION SHARED subnet in GRU region."
        } 
    ]
}

module "gru_rtb_subprv-database_vcn-dev" {
    source = "./modules/networking/route_table"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    display_name = "gru_rtb_subprv-database_vcn-dev"
    vcn_id = module.gru_vcn-dev.id

    route_rules = [
        {
          destination = local.gru_oci_services_cidr_block
          destination_type = "SERVICE_CIDR_BLOCK"
          network_entity_id = module.gru_sgw_vcn-dev.id
          description = "Route through Service Gateway"
        },
        {
           destination = "10.6.0.0/26"
           destination_type = "CIDR_BLOCK"
           network_entity_id = module.gru_drg.id
           description = "Route to reach PUBLIC PRODUCTION SHARED subnet in GRU region."
        } 
    ]
}

#-------------------
# Security Lists
#-------------------
module "gru_secl_subprv-backend_vcn-dev" {
    source = "./modules/networking/security_list"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    display_name = "gru_secl_subprv-backend_vcn-dev"
    vcn_id = module.gru_vcn-dev.id

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

module "gru_secl_subprv-database_vcn-dev" {
    source = "./modules/networking/security_list"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    display_name = "gru_secl_subprv-database_vcn-dev"
    vcn_id = module.gru_vcn-dev.id

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
module "gru_subprv-backend_vcn-dev" {
    source = "./modules/networking/subnet"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    vcn_id = module.gru_vcn-dev.id
    dhcp_options_id = module.gru_dhcp_vcn-dev.id
    route_table_id = module.gru_rtb_subprv-backend_vcn-dev.id
    security_list_ids = [module.gru_secl_subprv-backend_vcn-dev.id]

    display_name = "gru_subprv-backend_vcn-dev"    
    dns_label = "subprvbckend"
    cidr_block = "10.4.2.0/24"
    prohibit_public_ip_on_vnic = true
}

module "gru_subprv-database_vcn-dev" {
    source = "./modules/networking/subnet"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    vcn_id = module.gru_vcn-dev.id
    dhcp_options_id = module.gru_dhcp_vcn-dev.id
    route_table_id = module.gru_rtb_subprv-database_vcn-dev.id
    security_list_ids = [module.gru_secl_subprv-database_vcn-dev.id]

    display_name = "gru_subprv-database_vcn-dev"    
    dns_label = "subprvdb"
    cidr_block = "10.4.4.0/24"
    prohibit_public_ip_on_vnic = true
}