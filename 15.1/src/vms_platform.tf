variable "vm_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "VM web image family"
}

variable "vm_nat_name" {
  type        = string
  default     = "netology-nat-vm"
  description = "nat VM name"
}

variable "nat_image_id" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "nat VM imaage_id"
}

variable "vm_private_name" {
  type        = string
  default     = "netology-private-vm"
  description = "private VM name"
}

variable "vm_public_name" {
  type        = string
  default     = "netology-public-vm"
  description = "public VM name"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "VM web platform_id"
}



variable "vms_resources" {
  type        = map(object(
    {
      cores         = number
      memory        = number
      core_fraction = number
  }))
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
