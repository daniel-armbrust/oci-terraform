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
    source = "../modules/networking/vcn"
   
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
# Internet Gateway
#-------------------
module "vcp_igw_vcn-dr" {
    source = "../modules/networking/internet_gateway"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_igw_vcn-dr"
    vcn_id = module.vcp_vcn-dr.id
}

#-------------------
# NAT Gateway
#-------------------
module "vcp_ngw_vcn-dr" {
    source = "../modules/networking/nat_gateway"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_ngw_vcn-dr"
    vcn_id = module.vcp_vcn-dr.id
}

#-------------------
# Service Gateway
#-------------------
module "vcp_sgw_vcn-dr" {
    source = "../modules/networking/service_gateway"

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
    source = "../modules/networking/dhcp_options"

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
module "vcp_rtb_subpub-frontend_vcn-dr" {
    source = "../modules/networking/route_table"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_rtb_subpub-frontend_vcn-dr"
    vcn_id = module.vcp_vcn-dr.id

    route_rules = [
        {
          destination = local.anywhere
          destination_type = "CIDR_BLOCK"
          network_entity_id = module.vcp_igw_vcn-dr.id
          description = "Route through Internet Gateway"
        }
    ]
}

module "vcp_rtb_subprv-backend_vcn-dr" {
    source = "../modules/networking/route_table"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_rtb_subprv-backend_vcn-dr"
    vcn_id = module.vcp_vcn-dr.id

    route_rules = [
        {
          destination = local.anywhere
          destination_type = "CIDR_BLOCK"
          network_entity_id = module.vcp_ngw_vcn-dr.id
          description = "Route through NAT Gateway"
        }        
    ]
}

module "vcp_rtb_subprv-database_vcn-dr" {
    source = "../modules/networking/route_table"

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
           destination = "192.168.4.0/24"
           destination_type = "CIDR_BLOCK"
           network_entity_id = module.vcp_drg.id
           description = "Route to reach the PRIVATE PRODUCTION DATABASE subnet in GRU region."
        }
    ]
}

#-------------------
# Security Lists
#-------------------
module "vcp_secl_subpub-frontend_vcn-dr" {
    source = "../modules/networking/security_list"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_secl_subpub-frontend_vcn-dr"
    vcn_id = module.vcp_vcn-dr.id

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

module "vcp_secl_subprv-backend_vcn-dr" {
    source = "../modules/networking/security_list"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_secl_subprv-backend_vcn-dr"
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

module "vcp_secl_subprv-database_vcn-dr" {
    source = "../modules/networking/security_list"

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
module "vcp_subpub-frontend_vcn-dr" {
    source = "../modules/networking/subnet"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    vcn_id = module.vcp_vcn-dr.id
    dhcp_options_id = module.vcp_dhcp_vcn-dr.id
    route_table_id = module.vcp_rtb_subpub-frontend_vcn-dr.id
    security_list_ids = [module.vcp_secl_subpub-frontend_vcn-dr.id]

    display_name = "vcp_subpub-frontend_vcn-dr"    
    dns_label = "subpubfrtenddr"
    cidr_block = "172.16.1.0/24"    
    prohibit_public_ip_on_vnic = false
}

module "vcp_subprv-backend_vcn-dr" {
    source = "../modules/networking/subnet"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    vcn_id = module.vcp_vcn-dr.id
    dhcp_options_id = module.vcp_dhcp_vcn-dr.id
    route_table_id = module.vcp_rtb_subprv-backend_vcn-dr.id
    security_list_ids = [module.vcp_secl_subprv-backend_vcn-dr.id]

    display_name = "vcp_subprv-backend_vcn-dr"    
    dns_label = "subprvbckenddr"
    cidr_block = "172.16.2.0/24"
    prohibit_public_ip_on_vnic = true
}

module "vcp_subprv-database_vcn-dr" {
    source = "../modules/networking/subnet"

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
    cidr_block = "172.16.4.0/24"
    prohibit_public_ip_on_vnic = true
}