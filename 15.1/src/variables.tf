###cloud vars
# variable "token" {
#   type        = string
#   description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
# }

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "public CIDR"
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "private CIDR"
}

variable "nat_vm_ip" {
  type        = string
  default     = "192.168.10.254"
  description = "nat VM IP address"
}

variable "vpc_name" {
  type        = string
  default     = "clopro"
  description = "VPC network name"
}

variable "private_subnet_name" {
  type        = string
  default     = "private"
  description = "private subnet name"
}

variable "public_subnet_name" {
  type        = string
  default     = "public"
  description = "public subnet name"
}

variable "default_prefix" {
  type        = string
  default     = "0.0.0.0/0"
  description = "default_prefix"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}
