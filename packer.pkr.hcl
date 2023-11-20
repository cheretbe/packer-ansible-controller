
source "vagrant" "ansible-controller" {
  communicator       = "ssh"
  output_dir         = "output"
  output_vagrantfile = "vagrantfile.template"
  provider           = "virtualbox"
  source_path        = "ubuntu/jammy64"
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
