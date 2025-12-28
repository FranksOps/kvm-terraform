# 1. Define where the VM disks will be stored
resource "libvirt_pool" "ubuntu_pool" {
  name = "ubuntu_pool"
  type = "dir"
  path = "/srv/kvm/terraform-storage" # Terraform will create this
}

# 2. Create a Virtual Hard Drive based on the Ubuntu Cloud Image
resource "libvirt_volume" "ubuntu_qcow2" {
  name   = "ubuntu_qcow2"
  pool   = libvirt_pool.ubuntu_pool.name
  source = "/srv/kvm/images/ubuntu-24.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

# 3. Create the Cloud-Init "Instruction Disk"
resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = file("${path.module}/cloud_init.cfg")
  pool      = libvirt_pool.ubuntu_pool.name
}

# 4. Define the Virtual Machine (The "Domain")
resource "libvirt_domain" "ubuntu_vm" {
  name   = "devops-lab-node"
  memory = "2048"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default" # KVM's default NAT network
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  disk {
    volume_id = libvirt_volume.ubuntu_qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# Output the IP Address so we know where to SSH
output "ip" {
  value = libvirt_domain.ubuntu_vm.network_interface[0].addresses[0]
}
