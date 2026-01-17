packer {
  required_plugins {
    vagrant = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

variable "skip_add" {
  type    = bool
  default = false
}

source "vagrant" "ansible-controller" {
  communicator       = "ssh"
  output_dir         = "output"
  output_vagrantfile = "vagrantfile.template"
  provider           = "virtualbox"
  source_path        = "bento/debian-13"
  skip_add           = var.skip_add
}

build {
  sources = ["source.vagrant.ansible-controller"]

  provisioner "shell" {
    script = "./provision/provision.sh"
  }

  post-processor "shell-local" {
    inline = ["mv output/package.box output/ansible-controller.box"]
  }
}
