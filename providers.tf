terraform {
  required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }

  # Add this section below
  backend "http" {
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}
