resource "random_string" "unique_id" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

module "s3" {
  source = "git::https://github.com/terraform-yc-modules/terraform-yc-s3.git"

  bucket_name = "simple-bucket-${random_string.unique_id.result}"
  max_size = 1073741824
}

resource "yandex_iam_service_account" "sa" {
  name = "s3sa"
}

// Assigning a role to a service account
resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Creating a static access key
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_storage_object" "test-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "simple-bucket-${random_string.unique_id.result}"
  key        = "pic.jpg"
  source     = "./pic.jpg"
  acl        = "public-read"
  content_type = "image/jpeg"
}

resource "yandex_iam_service_account" "cc" {
  name = "ccsa"
}

// Assigning a role to a service account
resource "yandex_resourcemanager_folder_iam_member" "cc-admin" {
  folder_id = var.folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.cc.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "cc-admin-vpc" {
  folder_id = var.folder_id
  role      = "vpc.admin"
  member    = "serviceAccount:${yandex_iam_service_account.cc.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "cc-admin-lb" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.cc.id}"
}


resource "yandex_compute_instance_group" "netologytg" {
  name                = var.ig_name
  folder_id           = var.folder_id
  service_account_id  = "${yandex_iam_service_account.cc.id}"
  deletion_protection = false
  instance_template {
    platform_id = var.vm_platform_id
    resources {
      cores         = var.vms_resources.cores
      memory        = var.vms_resources.memory
      core_fraction = var.vms_resources.core_fraction
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.ig_image_id
      }
    }
    network_interface {
      network_id = yandex_vpc_network.clopro.id
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat        = true
    }

    metadata = {
      serial-port-enable = 1
      ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
      # user-data = "${file("cloud-init.yaml")}"
      user-data = "#cloud-config\n runcmd:\n  - 'export PUBLIC_IPV4=$(curl ifconfig.me)'\n  - 'echo Instance: $(hostname), IP Address: $PUBLIC_IPV4 \n http://simple-bucket-${random_string.unique_id.result}.storage.yandexcloud.net/pic.jpg | sudo tee /var/www/html/index.html > /dev/null'"
    }
    network_settings {
      type = "STANDARD"
    }
    
    scheduling_policy {
      preemptible = true
    }
  }

  scale_policy {
    fixed_scale {
      size = var.ig_size
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = var.ig_deploy_policy.max_unavailable
    max_creating    = var.ig_deploy_policy.max_creating
    max_expansion   = var.ig_deploy_policy.max_expansion
    max_deleting    = var.ig_deploy_policy.max_deleting
  }

  health_check {
    interval            = var.ig_health_check.interval
    timeout             = var.ig_health_check.timeout
    healthy_threshold   = var.ig_health_check.healthy_threshold
    unhealthy_threshold = var.ig_health_check.unhealthy_threshold
    http_options {
      port = var.ig_health_check.port
      path = var.ig_health_check.path
    }
  }

  load_balancer {
    target_group_name        = var.lb_tg_name
  }
}

resource "yandex_lb_network_load_balancer" "netologylb1" {
  name = var.nlb_name

  listener {
    name = var.nlb_listener.name
    port = var.nlb_listener.port
    external_address_spec {
      ip_version = var.nlb_listener.ip_version
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.netologytg.load_balancer.0.target_group_id

    healthcheck {
      name = var.nlb_tg_healthcheck.name
      http_options {
        port = var.nlb_tg_healthcheck.port
        path = var.nlb_tg_healthcheck.path
      }
    }
  }
}


resource "yandex_vpc_network" "clopro" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.clopro.id
  v4_cidr_blocks = var.public_cidr
}


