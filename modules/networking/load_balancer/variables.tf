#
# modules/networking/load_balancer/variables.tf
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_load_balancer
#

variable "compartment_id" {
    description = "(Required) (Updatable) The OCID of the compartment in which to create the Load Balancer."
    type = string    
}

variable "display_name" {
    description = "(Optional) (Updatable) A user-friendly name."
    type = string
    default = "lb"
}

variable "shape" {
    description = "(Required) (Updatable) The total pre-provisioned bandwidth (ingress plus egress). "
    type = string
    default = "10Mbps"

    validation {
       condition = can(regex("^(10|100|400|8000)Mbps$", var.shape))
       error_message = "The total pre-provisioned bandwidth must be: 10Mbps, 100Mbps, 400Mbps or 8000Mbps."
    }   
}

variable "subnet_ids" {
    description = "(Required) An array of subnet OCIDs."
    type = list(string)    
}

variable "is_private" {
    description = "(Optional) Public or Private Load Balancer."
    type = bool
    default = false
}

variable "nsg_ids" {
    description = "(Optional) (Updatable) An array of NSG OCIDs associated with this load balancer."
    type = list(string)
    default = []
}

variable "reserved_ip" {
    description = "(Optional) An array of reserved Ips. This reserved IP will not be deleted when load balancer is deleted."
    type = string
    default = ""
}

variable "backend_set" {
    description = " Backend Set resource in OCI for Load Balancer service."

    type = object({
       
       name = string
       policy = string
       
       health_checker_protocol = string
       health_checker_port = number
       health_checker_interval = optional(number)
       health_checker_return_code = optional(number)
       health_checker_timeout = optional(number)       
       health_checker_url = optional(string)       
    })

    validation {
       condition = can(regex("^(ROUND_ROBIN|LEAST_CONNECTIONS|IP_HASH)$", var.backend_set.policy))
       error_message = "The available policies for Load Balancer backend set are: ROUND_ROBIN, LEAST_CONNECTIONS or IP_HASH."
    }

    validation {
       condition = can(regex("^(TCP|HTTP)$", var.backend_set.health_checker_protocol))
       error_message = "The available policies for Load Balancer backend set are: ROUND_ROBIN, LEAST_CONNECTIONS or IP_HASH."
    }
}

variable "listener" {
    description = "Listener resource in OCI for Load Balancer service."

    type = object({
        name = optional(string)
        port = number
        protocol = string
    })

    default = {
        name = "lb_listener"
        port = 80
        protocol = "HTTP"
    }

    validation {
       condition = can(regex("^HTTP$", var.listener.protocol))
       error_message = "The protocol for Load Balancer Listener must be: HTTP."
    }
}

variable "backend" {
    description = "Backend resource in OCI for Load Balancer service."

    type = list(object({
        ip_address = string
        port = number
        backup = optional(bool)
        drain = optional(bool)
        offline = optional(bool)
        weight = optional(number)
    }))

    default = null
}
