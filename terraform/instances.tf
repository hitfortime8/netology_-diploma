data "yandex_compute_image" "os" {
    family = var.image_family
}

resource "yandex_compute_instance" "bastion" {
    name        = "bastion"
    hostname    = "bastion"
    platform_id = "standard-v3"
    zone        = var.zone_a

    resources {
        cores         = 2
        memory        = 2
        core_fraction = 20
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.os.id
            size     = 10
            type     = "network-hdd"
        }
    }
    network_interface {
        subnet_id           = yandex_vpc_subnet.public.id
        nat                 = true
        security_group_ids  = [yandex_vpc_security_group.bastion-sg.id]
    }
    metadata = {
        ssh-keys = "ubuntu:${file(var.public_key_bastion)}"
    }
    scheduling_policy {
        preemptible = true
    }
}

resource "yandex_compute_instance" "web" {
    count       = 2
    name        = "web-${count.index + 1}"
    hostname    = "web-${count.index + 1}"
    platform_id = "standard-v3"
    zone        = count.index == 0 ? var.zone_a : var.zone_b

    resources {
        cores         = 2
        memory        = 2
        core_fraction = 20
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.os.id
            size     = 10
            type     = "network-hdd"
        }
    }
    network_interface {
        subnet_id           = count.index == 0 ? yandex_vpc_subnet.private-a.id : yandex_vpc_subnet.private-b.id
        nat                 = false
        security_group_ids  = [yandex_vpc_security_group.internal-sg.id]
    }
    metadata = {
        ssh-keys = "ubuntu:${file(var.public_key_internal)}"
    }
    scheduling_policy {
        preemptible = true
    }
    depends_on = [yandex_compute_instance.bastion]
}

resource "yandex_compute_instance" "zabbix" {
    name        = "zabbix"
    hostname    = "zabbix"
    platform_id = "standard-v3"
    zone        = var.zone_a

    resources {
        cores         = 2
        memory        = 4
        core_fraction = 20
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.os.id
            size     = 10
            type     = "network-hdd"
        }
    }
    network_interface {
        subnet_id   = yandex_vpc_subnet.public.id
        nat                 = true
        security_group_ids  = [yandex_vpc_security_group.zabbix-sg.id]
    }
    metadata = {
        ssh-keys = "ubuntu:${file(var.public_key_bastion)}"
    }
    scheduling_policy {
        preemptible = true
    }
}

resource "yandex_compute_instance" "elastic" {
    name        = "elastic"
    hostname    = "elastic"
    platform_id = "standard-v3"
    zone        = var.zone_a

    resources {
        cores         = 2
        memory        = 4
        core_fraction = 20
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.os.id
            size     = 10
            type     = "network-hdd"
        }
    }
    network_interface {
        subnet_id           = yandex_vpc_subnet.private-a.id
        nat                 = false
        security_group_ids  = [yandex_vpc_security_group.elastic-sg.id]
    }
    metadata = {
        ssh-keys = "ubuntu:${file(var.public_key_internal)}"
    }
    scheduling_policy {
        preemptible = true
    }
}

resource "yandex_compute_instance" "kibana" {
    name        = "kibana"
    hostname    = "kibana"
    platform_id = "standard-v3"
    zone        = var.zone_a

    resources {
        cores         = 2
        memory        = 2
        core_fraction = 20
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.os.id
            size     = 10
            type     = "network-hdd"
        }
    }
    network_interface {
        subnet_id           = yandex_vpc_subnet.public.id
        nat                 = true
        security_group_ids  = [yandex_vpc_security_group.kibana-sg.id]
    }
    metadata = {
        ssh-keys = "ubuntu:${file(var.public_key_bastion)}"
    }
    scheduling_policy {
        preemptible = true
    }
}