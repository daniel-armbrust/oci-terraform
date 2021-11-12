#
# modules/networking/load_balancer/main.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_load_balancer
#

terraform { 
  experiments = [module_variable_optional_attrs]
}

resource "oci_load_balancer_load_balancer" "load_balancer" {
   compartment_id = var.compartment_id
   display_name = var.display_name
   shape = var.shape
   subnet_ids = var.subnet_ids
   is_private = var.is_private 

   reserved_ips {
      id = var.reserved_ip
   }
}

resource "oci_load_balancer_backend_set" "backend_set" {
   load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
     
   name = var.backend_set.name     
   policy = var.backend_set.policy

   health_checker {
       protocol = var.backend_set.health_checker_protocol
       interval_ms = var.backend_set.health_checker_interval
       port = var.backend_set.health_checker_port
       return_code = var.backend_set.health_checker_return_code
       timeout_in_millis = var.backend_set.health_checker_timeout
       url_path = var.backend_set.health_checker_url
   }
}

resource "oci_load_balancer_listener" "listener" {   
    default_backend_set_name = oci_load_balancer_backend_set.backend_set.name
    load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
    name = var.listener.name
    port = var.listener.port
    protocol = var.listener.protocol
}

resource "oci_load_balancer_backend" "backend" {        
    count = length(var.backend)

    backendset_name = oci_load_balancer_backend_set.backend_set.name
    load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id 

    ip_address = var.backend[count.index].ip_address
    port = var.backend[count.index].port
    
    backup = var.backend[count.index].backup
    drain = var.backend[count.index].drain
    offline = var.backend[count.index].offline
    weight = var.backend[count.index].weight
}