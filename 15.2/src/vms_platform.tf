

variable "ig_name" {
  type        = string
  default     = "netology-ig"
  description = "nat VM name"
}

variable "nat_image_id" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "nat VM imaage_id"
}


variable "ig_image_id" {
  type        = string
  default     = "fd827b91d99psvq5fjit"
  description = "LAMP ig image id"
}

variable "ig_size" {
  type        = number
  default     = 3
  description = "instance group size"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "VM web platform_id"
}

variable "ig_deploy_policy" {
  type        = object(
    {
      max_unavailable = number
      max_creating    = number
      max_expansion   = number
      max_deleting    = number
  })
  description = "ig deploy policy"
}

variable "lb_tg_name" {
  type        = string
  default     = "netologylbtg"
  description = "Load balancer target group"
}

variable "nlb_name" {
  type        = string
  default     = "netologynlb"
  description = "Network Load balancer name"
}

variable "nlb_listener_name" {
  type        = string
  default     = "netology_nlb_listener"
  description = "Network Load balancer Listener name"
}

variable "nlb_listener" {
  type        = object(
    {
      name         = string
      port         = number
      ip_version   = string

  })
  description = "Network Load balancer Listener settings"
}

variable "nlb_tg_healthcheck" {
  type        = object(
    {
      name         = string
      port         = number
      path   = string

  })
  description = "Network Load balancer attached target group healthcheck settings"
}

variable "ig_health_check" {
  type        = object(
    {
      interval            = number
      timeout             = number
      healthy_threshold   = number
      unhealthy_threshold = number
      port                = number
      path                = string
  })
  description = "ig health check"
}

variable "vms_resources" {
  type        = object(
    {
      cores         = number
      memory        = number
      core_fraction = number
  })
  description = "VMs resources"
}

variable "metadatas" {
  type        = object(
    {
      serial-port-enable = number
      ssh-keys           = string
  })
  description = "VMs metadata"
}
