# packer-ansible-controller
Debian 13 (Trixie) with Ansible installed (to be used as a controller in Vagrant setups)

### Debug

```shell
vagrant box add -f packer-ansible-controller-2del ./output/ansible-controller.box

vagrant box remove packer-ansible-controller-2del
```

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "packer-ansible-controller-2del"
  # config.vm.box = "cheretbe/ansible-controller"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--groups", "/__vagrant"]
  end
end
```

```shell
cat ~/.vagrant.d/boxes/packer-ansible-controller-2del/0/virtualbox/Vagrantfile
cat ~/.vagrant.d/boxes/packer-ansible-controller-2del/0/virtualbox/include/_Vagrantfile
```
