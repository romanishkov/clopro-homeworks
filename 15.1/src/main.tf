resource "yandex_vpc_network" "clopro" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.clopro.id
  v4_cidr_blocks = var.public_cidr

}
resource "yandex_vpc_subnet" "private" {
  name           = var.private_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.clopro.id
  v4_cidr_blocks = var.private_cidr
  route_table_id = yandex_vpc_route_table.rt.id

}

resource "yandex_vpc_route_table" "rt" {
  name       = "${ var.vpc_name }-route-table"
  network_id = yandex_vpc_network.clopro.id

  static_route {
    destination_prefix = var.default_prefix
    next_hop_address   = var.nat_vm_ip
  }
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_family
}

resource "yandex_compute_instance" "nat_vm" {
  name        = var.vm_nat_name
  platform_id = var.vm_platform_id
  resources {
    cores         = var.vms_resources.nat.cores
    memory        = var.vms_resources.nat.memory
    core_fraction = var.vms_resources.nat.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.nat_image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = var.nat_vm_ip
    nat       = true
  }
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

resource "yandex_compute_instance" "public_vm" {
  name        = var.vm_public_name
  platform_id = var.vm_platform_id
  resources {
    cores         = var.vms_resources.public.cores
    memory        = var.vms_resources.public.memory
    core_fraction = var.vms_resources.public.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

resource "yandex_compute_instance" "private_vm" {
  name        = var.vm_private_name
  platform_id = var.vm_platform_id
  resources {
    cores         = var.vms_resources.private.cores
    memory        = var.vms_resources.private.memory
    core_fraction = var.vms_resources.private.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    # nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

