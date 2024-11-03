output "test_output" {

  value = {
    nat = {
        instance_name = yandex_compute_instance.nat_vm.name
        external_ip = yandex_compute_instance.nat_vm.network_interface[0].nat_ip_address
        fqdn = yandex_compute_instance.nat_vm.fqdn
    },
    public = {
        instance_name = yandex_compute_instance.public_vm.name
        external_ip = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
        fqdn = yandex_compute_instance.public_vm.fqdn
    },
    private = {
        instance_name = yandex_compute_instance.private_vm.name
        external_ip = yandex_compute_instance.private_vm.network_interface[0].nat_ip_address
        fqdn = yandex_compute_instance.private_vm.fqdn
    }
  }
}