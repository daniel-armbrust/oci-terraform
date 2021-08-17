#
# gru_vcn-shared.tf
#

#---------------------------
# SHARED
#---------------------------

#-------------------
# VCN
#-------------------
module "gru_vcn-shared" {
    source = "./modules/networking/vcn"
   
    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_vcn-shared"
    cidr_blocks = ["10.6.0.0/24"]
    dns_label = "gruvcnshared"
    is_ipv6enabled = false
}

#-------------------
# Internet Gateway
#-------------------
module "gru_igw_vcn-shared" {
    source = "./modules/networking/internet_gateway"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_igw_vcn-shared"
    vcn_id = module.gru_vcn-shared.id
}

#-------------------
# DHCP Options
#-------------------
module "gru_dhcp_vcn-shared" {
    source = "./modules/networking/dhcp_options"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_dhcp_vcn-shared"
    vcn_id = module.gru_vcn-shared.id
}

#-------------------
# Route Tables
#-------------------
module "gru_rtb_subpub-frontend_vcn-shared" {
    source = "./modules/networking/route_table"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_rtb_subpub-frontend_vcn-shared"
    vcn_id = module.gru_vcn-shared.id

    route_rules = [
        {
           destination = local.anywhere
           destination_type = "CIDR_BLOCK"
           network_entity_id = module.gru_igw_vcn-shared.id
           description = "Route through Internet Gateway"
        },        
        {
           destination = "10.0.1.0/24"
           destination_type = "CIDR_BLOCK"
           network_entity_id = module.gru_drg.id
           description = "Route to reach PUBLIC PRODUCTION FRONTEND subnet in GRU region."
        },
        {
           destination = "10.0.2.0/24"
           destination_type = "CIDR_BLOCK"
           network_entity_id = module.gru_drg.id
           description = "Route to reach PRIVATE PRODUCTION BACKEND subnet in GRU region."
        },
        {
           destination = "10.0.4.0/24"
           destination_type = "CIDR_BLOCK"
           network_entity_id = module.gru_drg.id
           description = "Route to reach PRIVATE PRODUCTION DATABASE subnet in GRU region."
        }
    ]
}

#-------------------
# Security Lists
#-------------------
module "gru_secl_subpub-frontend_vcn-shared" {
    source = "./modules/networking/security_list"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_secl_subpub-frontend_vcn-shared"
    vcn_id = module.gru_vcn-shared.id

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
           source       = "201.95.40.251/32"
           source_type  = "CIDR_BLOCK"           
           protocol     = local.all_protocols,
           stateless    = false                      
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

#-------------------
# Subnets
#-------------------
module "gru_subpub-frontend_vcn-shared" {
    source = "./modules/networking/subnet"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    vcn_id = module.gru_vcn-shared.id
    dhcp_options_id = module.gru_dhcp_vcn-shared.id
    route_table_id = module.gru_rtb_subpub-frontend_vcn-shared.id
    security_list_ids = [module.gru_secl_subpub-frontend_vcn-shared.id]

    display_name = "gru_subpub-frontend_vcn-shared"    
    dns_label = "subpubfrtend"
    cidr_block = "10.6.0.0/26"    
    prohibit_public_ip_on_vnic = false
}