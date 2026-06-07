locals {
  backup_disk_ids = [
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.web[0].boot_disk[0].disk_id,
    yandex_compute_instance.web[1].boot_disk[0].disk_id,
    yandex_compute_instance.zabbix.boot_disk[0].disk_id,
    yandex_compute_instance.elastic.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id
  ]
}

resource "yandex_compute_snapshot_schedule" "daily_vm_snapshots" {
  name        = "diplom-daily-vm-snapshots"
  description = "Daily snapshots for all vms"

  schedule_policy {
    expression = "0 2 * * *"
  }

  retention_period = "168h"

  snapshot_spec {
    description = "Retention is 7 days."

    labels = {
      project = "diplom"
      type    = "daily-backup"
    }
  }

  disk_ids = local.backup_disk_ids
}