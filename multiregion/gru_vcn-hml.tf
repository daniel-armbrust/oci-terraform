#
# gru_vcn-hml.tf
#

#---------------------------
# HOMOLOGATION
#---------------------------

#-------------------
# VCN
#-------------------
module "gru_vcn-hml" {
    source = "./modules/networking/vcn"
    
    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    display_name = "gru_vcn-hml"
    cidr_blocks = ["10.2.0.0/16"]
    dns_label = "gruvcnhml"
    is_ipv6enabled = false
}

#-------------------
# Internet Gateway
#-------------------
module "gru_igw_vcn-hml" {
    source = "./modules/networking/internet_gateway"

    providers = {
       oci = oci.gru
    }  

    compartment_id = var.compartment_id
    display_name = "gru_igw_vcn-hml"
    vcn_id = module.gru_vcn-hml.id
}

#-------------------
# NAT Gateway
#-------------------
module "gru_ngw_vcn-hml" {
    source = "./modules/networking/nat_gateway"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    display_name = "gru_ngw_vcn-hml"
    vcn_id = module.gru_vcn-hml.id
}

#-------------------
# Service Gateway
#-------------------
module "gru_sgw_vcn-hml" {
    source = "./modules/networking/service_gateway"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    display_name = "gru_sgw_vcn-hml"
    vcn_id = module.gru_vcn-hml.id
    service_id = local.gru_all_oci_services
}

#-------------------
# DHCP Options
#-------------------
module "gru_dhcp_vcn-hml" {
    source = "./modules/networking/dhcp_options"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    display_name = "gru_dhcp_vcn-hml"
    vcn_id = module.gru_vcn-hml.id
}

#-------------------
# Route Tables
#-------------------
module "gru_rtb_subpub-frontend_vcn-hml" {
    source = "./modules/networking/route_table"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    display_name = "gru_rtb_subpub-frontend_vcn-hml"
    vcn_id = module.gru_vcn-hml.id

    route_rules = [
        {
          destination = local.anywhere
          destination_type = "CIDR_BLOCK"
          network_entity_id = module.gru_igw_vcn-hml.id
          description = "Route through Internet Gateway"
        },
        {
           destination = "10.6.0.0/26"
           destination_type = "CIDR_BLOCK"
           network_entity_id = module.gru_drg.id
           description = "Route to reach PUBLIC PRODUCTION SHARED subnet in GRU region."
        } 
    ]
}

module "gru_rtb_subprv-backend_vcn-hml" {
    source = "./modules/networking/route_table"

    providers = {
       oci = oci.gru
    }  

    compartment_id = var.compartment_id
    display_name = "gru_rtb_subprv-backend_vcn-hml"
    vcn_id = module.gru_vcn-hml.id

    route_rules = [
        {
          destination = local.anywhere
          destination_type = "CIDR_BLOCK"
          network_entity_id = module.gru_ngw_vcn-hml.id
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

module "gru_rtb_subprv-database_vcn-hml" {
    source = "./modules/networking/route_table"

    providers = {
       oci = oci.gru
    }  

    compartment_id = var.compartment_id
    display_name = "gru_rtb_subprv-database_vcn-hml"
    vcn_id = module.gru_vcn-hml.id

    route_rules = [
        {
          destination = local.gru_oci_services_cidr_block
          destination_type = "SERVICE_CIDR_BLOCK"
          network_entity_id = module.gru_sgw_vcn-hml.id
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
module "gru_secl_subpub-frontend_vcn-hml" {
    source = "./modules/networking/security_list"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    display_name = "gru_secl_subpub-frontend_vcn-hml"
    vcn_id = module.gru_vcn-hml.id

    // TODO: change dst_min_port to include an array of values

    egress_security_rules = [
       {
           description      = "Allow access from OCI to ALL."
           destination      = local.anywhere
           destination_type = "CIDR_BLOCK"         
           protocol         = local.all_protocols
           stateless        = false           
       }
    ]

    ingress_security_rules = [
        {
           description  = "Allow access from INTERNET to 80/TCP."
           source       = local.anywhere
           source_type  = "CIDR_BLOCK"           
           protocol     = local.tcp_protocol          
           stateless    = false
           dst_min_port = 80
           dst_max_port = 80
           src_min_port = 1024
           src_max_port = 65535           
        },
        {
           description  = "Allow access from INTERNET to 443/TCP."
           source       = local.anywhere
           source_type  = "CIDR_BLOCK"
           protocol     = local.tcp_protocol
           stateless    = false
           dst_min_port = 443
           dst_max_port = 443
           src_min_port = 1024
           src_max_port = 65535           
        },
        {
           // To enable MTU negotiation for ingress internet traffic via IPv4, 
           // make sure to allow type 3 (Destination Unreachable) and
           // code 4 (Fragmentation Needed and Don't Fragment was Set).            
           description  = "Allow ICMP 3 (Destination Unreachable) and code 4 (Fragmentation Needed and Don't Fragment was Set)."
           source       = local.anywhere
           source_type  = "CIDR_BLOCK"           
           protocol     = local.icmp_protocol
           stateless    = false
           icmp_type    = 3
           icmp_code    = 4           
        }
    ]
}

module "gru_secl_subprv-backend_vcn-hml" {
    source = "./modules/networking/security_list"

    providers = {
       oci = oci.gru
    }  

    compartment_id = var.compartment_id
    display_name = "gru_secl_subprv-backend_vcn-hml"
    vcn_id = module.gru_vcn-hml.id

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

module "gru_secl_subprv-database_vcn-hml" {
    source = "./modules/networking/security_list"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    display_name = "gru_secl_subprv-database_vcn-hml"
    vcn_id = module.gru_vcn-hml.id

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
module "gru_subpub-frontend_vcn-hml" {
    source = "./modules/networking/subnet"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    vcn_id = module.gru_vcn-hml.id
    dhcp_options_id = module.gru_dhcp_vcn-hml.id
    route_table_id = module.gru_rtb_subpub-frontend_vcn-hml.id
    security_list_ids = [module.gru_secl_subpub-frontend_vcn-hml.id]

    display_name = "gru_subpub-frontend_vcn-hml"  
    dns_label = "subpubfrtend"  
    cidr_block = "10.2.1.0/24"
    prohibit_public_ip_on_vnic = false
}

module "gru_subprv-backend_vcn-hml" {
    source = "./modules/networking/subnet"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    vcn_id = module.gru_vcn-hml.id
    dhcp_options_id = module.gru_dhcp_vcn-hml.id
    route_table_id = module.gru_rtb_subprv-backend_vcn-hml.id
    security_list_ids = [module.gru_secl_subprv-backend_vcn-hml.id]

    display_name = "gru_subprv-backend_vcn-hml"   
    dns_label = "subprvbckend" 
    cidr_block = "10.2.2.0/24"
    prohibit_public_ip_on_vnic = true
}

module "gru_subprv-database_vcn-hml" {
    source = "./modules/networking/subnet"

    providers = {
       oci = oci.gru
    } 

    compartment_id = var.compartment_id
    vcn_id = module.gru_vcn-hml.id
    dhcp_options_id = module.gru_dhcp_vcn-hml.id
    route_table_id = module.gru_rtb_subprv-database_vcn-hml.id
    security_list_ids = [module.gru_secl_subprv-database_vcn-hml.id]

    display_name = "gru_subprv-database_vcn-hml"    
    dns_label = "subprvdb"
    cidr_block = "10.2.4.0/24"
    prohibit_public_ip_on_vnic = true
}