vms_resources = {
    nat={
       cores         = 2
       memory        = 1
       core_fraction = 5
    },
    public= {
       cores         = 2
       memory        = 1
       core_fraction = 5
    },
    private= {
       cores         = 2
       memory        = 2
       core_fraction = 20
    }
}

metadatas = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFGvcDVoL255t4B5JqSTzMJ/ktFMMeFmGFzFFWxSOvTw rom@localhost.localdomain"
}
