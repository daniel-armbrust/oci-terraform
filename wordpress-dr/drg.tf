#
# drg.tf
# https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingDRGs.htm
#

#-------------------
# DRG
#-------------------
module "gru_drg" {
    source = "../modules/networking/drg"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "gru_drg"
}

module "vcp_drg" {
    source = "../modules/networking/drg"

    providers = {
       oci = oci.vcp
    }

    compartment_id = var.compartment_id
    display_name = "vcp_drg"
}

#-------------------
# DRG Remote Peering
#-------------------
module "vcp_rpc_acceptor" {
    source = "../modules/networking/drg_remote_peering"

    providers = {
       oci = oci.vcp
    }
    
    compartment_id = var.compartment_id
    drg_id = module.vcp_drg.id       
    display_name = "vcp_rpc_acceptor"
}

module "gru_rpc_requestor" {
    source = "../modules/networking/drg_remote_peering"

    providers = {
       oci = oci.gru
    }
    
    compartment_id = var.compartment_id
    drg_id = module.gru_drg.id
    peer_id = module.vcp_rpc_acceptor.id
    region_name = local.region_names.vcp
    display_name = "gru_rpc_requestor"
}

#-------------------
# DRG Attachments
#-------------------

# GRU
module "gru_drg-attch_vcn-prd" {
    source = "../modules/networking/drg_attachment"

    providers = {
       oci = oci.gru
    }
    
    drg_id = module.gru_drg.id    
    network_id = module.gru_vcn-prd.id
    network_type = "VCN"
    display_name = "gru_drg-attch_vcn-prd"
}

# VCP
module "vcp_drg-attch_vcn-dr" {
    source = "../modules/networking/drg_attachment"

    providers = {
       oci = oci.vcp
    }
    
    drg_id = module.vcp_drg.id    
    network_id = module.vcp_vcn-dr.id
    network_type = "VCN"
    display_name = "vcp_drg-attch_vcn-dr"
}


#-------------------
# DRG Route Rules
#-------------------
module "gru_rtb_drg" {
    source = "../modules/networking/drg_route_table"

    providers = {
       oci = oci.gru
    }

    drg_id = module.gru_drg.id 
    display_name = "gru_rtb_drg"
    is_ecmp_enabled = false

     route_rules = [
        {
            destination = "192.168.0.0/16"
            nexthop_drg_attachment_id = module.gru_drg-attch_vcn-prd.id
        }
    ]   
}

module "vcp_rtb_drg" {
    source = "../modules/networking/drg_route_table"

    providers = {
       oci = oci.vcp
    }

    drg_id = module.vcp_drg.id 
    display_name = "vcp_rtb_drg"
    is_ecmp_enabled = false

     route_rules = [
        {
            destination = "172.16.0.0/16"
            nexthop_drg_attachment_id = module.vcp_drg-attch_vcn-dr.id
        }
    ]   
}