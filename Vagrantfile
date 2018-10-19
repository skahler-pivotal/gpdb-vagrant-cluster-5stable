Vagrant.configure("2") do |config|
		config.vm.box = "bento/centos-7"
		config.vm.provision :shell, :inline => "ulimit -n 8096"

	config.vm.provider :virtualbox do |v, override|
		v.customize ["modifyvm", :id, "--memory", "1024"]
		v.customize ["modifyvm", :id, "--vram", "16"]
	end

	config.vm.define :sdw1 do |sdw1_config|
 		sdw1_config.vm.network :private_network, ip: "172.16.1.12"
 		sdw1_config.vm.hostname = "sdw1"
		sdw1_config.vm.provision :shell, :path => "setup_host.sh"
		sdw1_config.vm.provision :shell, :path => "unmount_vagrant.sh"
	end

	config.vm.define :sdw2 do |sdw2_config|
		sdw2_config.vm.network :private_network, ip: "172.16.1.13"
		sdw2_config.vm.hostname = "sdw2"
		sdw2_config.vm.provision :shell, :path => "setup_host.sh"
		sdw2_config.vm.provision :shell, :path => "unmount_vagrant.sh"
	end

	config.vm.define :mdw do |mdw_config|
		mdw_config.vm.provider :virtualbox do |v3|
			v3.customize ["modifyvm", :id, "--memory", "2048"]
		end
 		mdw_config.vm.network :private_network, ip: "172.16.1.11"
		mdw_config.vm.network "forwarded_port", guest: 5432, host: 5433
		mdw_config.vm.hostname = "mdw"
		mdw_config.vm.provision :shell, :path => "relax_directory_perms.sh"
		mdw_config.vm.provision :shell, :path => "setup_host.sh"
		mdw_config.vm.provision :shell, :path => "setup_build.sh"
		mdw_config.vm.provision :shell, :path => "setup_master.sh"
		mdw_config.vm.provision :shell, :path => "change_password.sh"
		mdw_config.vm.provision :shell, :path => "build_gpdb.sh"
		mdw_config.vm.provision :shell, :path => "install_gpdb_on_hosts.sh"
		mdw_config.vm.provision :shell, :path => "run_system_verification_tests.sh"
		mdw_config.vm.provision :shell, :path => "initialize_gpdb.sh"
		mdw_config.vm.provision :shell, :path => "unmount_vagrant.sh"
	end
end
