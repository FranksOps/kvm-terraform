terraform {
  required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6" # Current stable version for KVM
    }
  }
}

# This tells Terraform to connect to the local QEMU/KVM system
provider "libvirt" {
  uri = "qemu:///system"
}
