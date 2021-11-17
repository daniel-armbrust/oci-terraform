#
# vcn-prd.tf
# https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingVCNs.htm
#

#-------------------
# VCN
#-------------------
module "vcn-prd" {
    source = "../modules/networking/vcn"
   
    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "vcn-prd"
    cidr_blocks = ["192.168.0.0/16"]
    dns_label = "vcnprd"
    is_ipv6enabled = false
}

#-------------------
# Internet Gateway
#-------------------
module "igw_vcn-prd" {
    source = "../modules/networking/internet_gateway"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "igw_vcn-prd"
    vcn_id = module.vcn-prd.id
}

#-------------------
# NAT Gateway
#-------------------
module "ngw_vcn-prd" {
    source = "../modules/networking/nat_gateway"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "ngw_vcn-prd"
    vcn_id = module.vcn-prd.id
}

#-------------------
# Service Gateway
#-------------------
module "sgw_vcn-prd" {
    source = "../modules/networking/service_gateway"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "sgw_vcn-prd"
    vcn_id = module.vcn-prd.id
    service_id = local.gru_all_oci_services
}

#-------------------
# DHCP Options
#-------------------
module "dhcp_vcn-prd" {
    source = "../modules/networking/dhcp_options"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "dhcp_vcn-prd"
    vcn_id = module.vcn-prd.id
}

#-------------------
# Route Tables
#-------------------
module "rtb_subpub-frontend_vcn-prd" {
    source = "../modules/networking/route_table"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "rtb_subpub-frontend_vcn-prd"
    vcn_id = module.vcn-prd.id

    route_rules = [
        {
          destination = local.anywhere
          destination_type = "CIDR_BLOCK"
          network_entity_id = module.igw_vcn-prd.id
          description = "Route through Internet Gateway"
        }
    ]
}

module "rtb_subprv-backend_vcn-prd" {
    source = "../modules/networking/route_table"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "rtb_subprv-backend_vcn-prd"
    vcn_id = module.vcn-prd.id

    route_rules = [
        {
          destination = local.anywhere
          destination_type = "CIDR_BLOCK"
          network_entity_id = module.ngw_vcn-prd.id
          description = "Route through NAT Gateway"
        }        
    ]
}

module "rtb_subprv-database_vcn-prd" {
    source = "../modules/networking/route_table"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "rtb_subprv-database_vcn-prd"
    vcn_id = module.vcn-prd.id

    route_rules = [
        {
          destination = local.gru_oci_services_cidr_block
          destination_type = "SERVICE_CIDR_BLOCK"
          network_entity_id = module.sgw_vcn-prd.id
          description = "Route through Service Gateway"
        }
    ]
}

#-------------------
# Security Lists
#-------------------
module "secl_subpub-frontend_vcn-prd" {
    source = "../modules/networking/security_list"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "secl_subpub-frontend_vcn-prd"
    vcn_id = module.vcn-prd.id

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

module "secl_subprv-backend_vcn-prd" {
    source = "../modules/networking/security_list"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "secl_subprv-backend_vcn-prd"
    vcn_id = module.vcn-prd.id

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

module "secl_subprv-database_vcn-prd" {
    source = "../modules/networking/security_list"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "secl_subprv-database_vcn-prd"
    vcn_id = module.vcn-prd.id

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
module "subpub-frontend_vcn-prd" {
    source = "../modules/networking/subnet"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    vcn_id = module.vcn-prd.id
    dhcp_options_id = module.dhcp_vcn-prd.id
    route_table_id = module.rtb_subpub-frontend_vcn-prd.id
    security_list_ids = [module.secl_subpub-frontend_vcn-prd.id]

    display_name = "subpub-frontend_vcn-prd"    
    dns_label = "subpubfrtend"
    cidr_block = "192.168.1.0/24"    
    prohibit_public_ip_on_vnic = false
}

module "subprv-backend_vcn-prd" {
    source = "../modules/networking/subnet"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    vcn_id = module.vcn-prd.id
    dhcp_options_id = module.dhcp_vcn-prd.id
    route_table_id = module.rtb_subprv-backend_vcn-prd.id
    security_list_ids = [module.secl_subprv-backend_vcn-prd.id]

    display_name = "subprv-backend_vcn-prd"    
    dns_label = "subprvbckend"
    cidr_block = "192.168.2.0/24"
    prohibit_public_ip_on_vnic = true
}

module "subprv-database_vcn-prd" {
    source = "../modules/networking/subnet"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    vcn_id = module.vcn-prd.id
    dhcp_options_id = module.dhcp_vcn-prd.id
    route_table_id = module.rtb_subprv-database_vcn-prd.id
    security_list_ids = [module.secl_subprv-database_vcn-prd.id]

    display_name = "subprv-database_vcn-prd"
    dns_label = "subprvdb"
    cidr_block = "192.168.4.0/24"
    prohibit_public_ip_on_vnic = true
}