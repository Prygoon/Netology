terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id  = "b1g0kbqchihj27eqghpe"
  folder_id = "b1gj3ksb70peir427jks"
  zone      = "ru-central1-b"
}

resource "yandex_compute_instance" "vm-instance" {
  count = var.num_instances

  name        = "alma${count.index}"
  platform_id = "standard-v2"

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd81m6n1rh1v2mpjft86"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_addresses" {
  value = yandex_compute_instance.vm-instance.*.network_interface.0.ip_address
}

output "external_ip_addresses" {
  value = yandex_compute_instance.vm-instance.*.network_interface.0.nat_ip_address
}
