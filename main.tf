terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone      = var.yandex_zone
  token     = var.yandex_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
}

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = var.yandex_zone
  size     = 20
  image_id = var.vm_image_ids.ubuntu
}

resource "yandex_compute_instance" "vm-ubuntu" {
  name = "vm-ubuntu"

  resources {
    cores  = 2
    memory = 2
  }

  scheduling_policy {
    preemptible = false
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys  = var.ssh_public_key
    user-data = <<EOF
    #cloud-config
    users:
      - name: yc-user
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        lock_passwd: true
        ssh_authorized_keys:
          - ${file("~/.ssh/id_ed25519.pub")}

      - name: ansible
        groups: users, admin, wheel, sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        lock_passwd: true
        ssh_authorized_keys:
          - ${file("~/.ssh/id_ed25519.pub")}
    EOF
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.yandex_zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "external_ip_address_vm_ubuntu" {
  value = yandex_compute_instance.vm-ubuntu.network_interface.0.nat_ip_address
}