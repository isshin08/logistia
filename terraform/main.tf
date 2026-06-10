locals {
  vms = {
    db-server = {
      vmid    = 100
      bridge  = "vmbr20"
      ip      = "192.168.20.10"
      gateway = "192.168.20.1"
      cores   = 2
      memory  = 2048
      disk    = 20
    }
    runner-server = {
      vmid    = 101
      bridge  = "vmbr50"
      ip      = "192.168.50.10"
      gateway = "192.168.50.1"
      cores   = 2
      memory  = 2048
      disk    = 20
    }
    soc-server = {
      vmid    = 102
      bridge  = "vmbr30"
      ip      = "192.168.30.10"
      gateway = "192.168.30.1"
      cores   = 4
      memory  = 4096
      disk    = 50
    }
    web-server = {
      vmid    = 103
      bridge  = "vmbr20"
      ip      = "192.168.20.20"
      gateway = "192.168.20.1"
      cores   = 2
      memory  = 2048
      disk    = 20
    }
    ia-server = {
      vmid    = 104
      bridge  = "vmbr20"
      ip      = "192.168.20.30"
      gateway = "192.168.20.1"
      cores   = 2
      memory  = 2048
      disk    = 20
    }
  }
}

resource "proxmox_virtual_environment_vm" "vms" {
  for_each  = local.vms
  node_name = var.proxmox_node
  vm_id     = each.value.vmid
  name      = each.key
 #kvm       = false

  clone {
    vm_id = 9000
  }

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = each.value.disk
  }

  network_device {
    bridge = each.value.bridge
    model  = "virtio"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = each.value.gateway
      }
    }
    user_account {
      username = "debian"
      keys     = [var.ssh_public_key]
    }
    dns {
      servers = ["8.8.8.8"]
    }
  }
}
