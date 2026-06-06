resource "yandex_vpc_security_group" "bastion-sg" {
    name        = "bastion-sg"
    description = "Allow SSH"
    network_id  = yandex_vpc_network.main.id

    ingress {
        protocol        = "TCP"
        description     = "SSH from anywhere"
        v4_cidr_blocks  = ["0.0.0.0/0"]
        port            = 22
    }
    egress {
        protocol        = "ANY"
        description     = "Allow all outgoing"
        v4_cidr_blocks  = ["0.0.0.0/0"]
        from_port       = 0
        to_port         = 65535
    }
}

resource "yandex_vpc_security_group" "internal-sg" {
    name        = "internal-sg"
    description = "Allow SSH from Bastion and HTTP from ALB"
    network_id  = yandex_vpc_network.main.id

    ingress {
        protocol        = "TCP"
        description     = "SSH from Bastion"
        v4_cidr_blocks  = ["10.1.0.0/24"]
        port            = 22
    }
    ingress {
        protocol        = "TCP"
        description     = "HTTP from ALB"
        v4_cidr_blocks  = ["10.1.0.0/24"]
        port            = 80
    }
    ingress {
        protocol        = "TCP"
        description     = "zabbix agent"
        v4_cidr_blocks  = ["10.1.0.0/24"]
        port            = 10050
    }
    egress {
        protocol        = "ANY"
        description     = "Allow all outgoing"
        v4_cidr_blocks  = ["0.0.0.0/0"]
        from_port       = 0
        to_port         = 65535
    }
}

resource "yandex_vpc_security_group" "zabbix-sg" {
    name        = "zabbix-sg"
    network_id  = yandex_vpc_network.main.id

    ingress {
        protocol        = "TCP"
        description     = "SSH from bastion"
        v4_cidr_blocks  = ["10.1.0.0/24"]
        port            = 22
    }
    ingress {
        protocol        = "TCP"
        description     = "Zabbix web UI"
        v4_cidr_blocks  = ["0.0.0.0/0"]
        port            = 80
    }
    ingress {
        protocol        = "TCP"
        description     = "Zabbix agent"
        v4_cidr_blocks  = ["10.0.0.0/8"]
        port            = 10050
    }
    egress {
        protocol        = "ANY"
        v4_cidr_blocks  = ["0.0.0.0/0"]
    }
}

resource "yandex_vpc_security_group" "kibana-sg" {
    name        = "kibana-sg"
    network_id  = yandex_vpc_network.main.id

    ingress {
        protocol        = "TCP"
        description     = "SSH from bastion"
        v4_cidr_blocks  = ["10.1.0.0/24"]
        port            = 22
    }
    ingress {
        protocol        = "TCP"
        description     = "zabbix agent"
        v4_cidr_blocks  = ["10.1.0.0/24"]
        port            = 10050
    }
    ingress {
        protocol        = "TCP"
        description     = "Kibana web"
        v4_cidr_blocks  = ["0.0.0.0/0"]
        port            = 5601
    }
    egress {
        protocol        = "ANY"
        v4_cidr_blocks  = ["0.0.0.0/0"]
    }
}

resource "yandex_vpc_security_group" "elastic-sg" {
    name        = "elastic-sg"
    network_id  = yandex_vpc_network.main.id

    ingress {
        protocol        = "TCP"
        description     = "Elastic api"
        v4_cidr_blocks  = ["10.0.0.0/8"]
        port            = 9200
    }
    ingress {
        protocol        = "TCP"
        description     = "zabbix agent"
        v4_cidr_blocks  = ["10.1.0.0/24"]
        port            = 10050
    }
    ingress {
        protocol        = "TCP"
        description     = "SSH from bastion"
        v4_cidr_blocks  = ["10.1.0.0/24"]
        port            = 22
    }
    egress {
        protocol        = "ANY"
        v4_cidr_blocks  = ["0.0.0.0/0"]
    }
}