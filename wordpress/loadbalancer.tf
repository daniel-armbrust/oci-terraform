#
# gru_loadbalancer.tf
# https://docs.oracle.com/en-us/iaas/Content/Balance/Concepts/balanceoverview.htm
#

#-------------------
# Load Balancing
#-------------------

module "lbpub-wordpress" {
    source = "../modules/networking/load_balancer"

    providers = {
       oci = oci.gru
    }

    compartment_id = var.compartment_id
    display_name = "lbpub-wordpress"
    reserved_ip = module.lbpub-wordpress_pubip.id

    subnet_ids = [module.subpub-frontend_vcn-prd.id]

    backend_set = {
        name = "lbpub-wordpress_bckset-1"
        policy = "ROUND_ROBIN"

        health_checker_protocol = "HTTP"
        health_checker_port = 80
        health_checker_timeout = 10000
        health_checker_return_code = 200
        health_checker_url = "/"
    }    

    listener = {
        name = "lbpub-wordpress_listener"
        port = 80
        protocol = "HTTP"
    }

    backend = [
       {          
          ip_address = module.vmlnx-wordpress.private_ip
          port = 80
       }
    ]
}