Vagrant.configure("2") do |config|
	config.vm.define :vm1 do |vm1|
		vm1.vm.box = "bento/ubuntu-20.04"
		vm1.vm.hostname = "vm1"
		vm1.vm.network :private_network, ip: "192.168.100.121"
		vm1.vm.provision "shell", path: "script_provision_vm1.sh"
		vm1.vm.synced_folder "carpeta_sincronizada", "/home/vagrant/carpeta_sincronizada"
		vm1.vm.provider "virtualbox" do |v|
			v.name = "vm1"
			v.memory = 1024
			v.cpus =1
		end
	end

	config.vm.define :vm2 do |vm2|
		vm2.vm.box = "bento/ubuntu-20.04"
		vm2.vm.hostname = "vm2"
		vm2.vm.network :private_network, ip: "192.168.100.122"
		vm2.vm.provision "shell", path: "script_provision_vm2.sh"
		vm2.vm.synced_folder "carpeta_sincronizada", "/home/vagrant/carpeta_sincronizada"
		vm2.vm.provider "virtualbox" do |v|
			v.name = "vm2"
			v.memory = 1024
			v.cpus =1
		end
	end

	config.vm.define :vm3 do |vm3|
		vm3.vm.box = "bento/ubuntu-20.04"
		vm3.vm.hostname = "vm3"
		vm3.vm.network :private_network, ip: "192.168.100.123"
		vm3.vm.provision "shell", path: "script_provision_vm3.sh"
		vm3.vm.synced_folder "carpeta_sincronizada", "/home/vagrant/carpeta_sincronizada"
		vm3.vm.provider "virtualbox" do |v|
			v.name = "vm3"
			v.memory = 1024
			v.cpus =1
		end
	end
end