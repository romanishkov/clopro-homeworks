vms_resources = {
   cores         = 2
   memory        = 1
   core_fraction = 5
}

ig_deploy_policy = {
   max_unavailable = 2
   max_creating    = 3
   max_expansion   = 2
   max_deleting    = 3
}

ig_health_check = {
   interval             = 5
   timeout              = 3
   healthy_threshold    = 2
   unhealthy_threshold  = 3
   port                 = 80
   path                 = "/"
}

nlb_listener = {
   name          = "netologynlblistener"
   port          = 80
   ip_version    = "ipv4"
}

nlb_tg_healthcheck = {
   name          = "http"
   port          = 80
   path          = "/"
}


metadatas = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFGvcDVoL255t4B5JqSTzMJ/ktFMMeFmGFzFFWxSOvTw rom@localhost.localdomain"
}
