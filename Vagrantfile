# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

machines = {
            "consul" => {:ip => "192.168.33.201", :mem => 1024, :roles => ["consul_bootstrap", "docker_registry"]},
            "mesos-master1" => {:ip => "192.168.33.10", :mem => 512, :roles => ["mesos_master"]},
            "mesos-master2" => {:ip => "192.168.33.11", :mem => 512, :roles => ["mesos_master"]},
            "mesos-master3" => {:ip => "192.168.33.12", :mem => 512, :roles => ["mesos_master"]},
            "mesos-slave1" => {:ip => "192.168.33.101", :mem => 1024, :roles => ["consul_client","mesos_slave"]},
            "mesos-slave2" => {:ip => "192.168.33.102", :mem => 1024, :roles => ["consul_client","mesos_slave"]}
            }

def optimization_by_caching(config)
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.omnibus.cache_packages = true if Vagrant.has_plugin?("vagrant-omnibus")
    config.cache.enable :apt
    config.cache.enable :apt_lists
    config.cache.enable :chef
    config.cache.enable :chef_gem
    config.cache.enable :gem
    # to prevent privilege prompt password edit /etc/sudoers following the guidelines here : http://docs.vagrantup.com/v2/synced-folders/nfs.html
    config.cache.synced_folder_opts = { type: :nfs, mount_options: ['rw', 'vers=3', 'tcp', 'nolock'] }
  else
    puts "WARN : You should consider installing vagrant-cachier or you will download things several times"
  end
  if Vagrant.has_plugin?("vagrant-omnibus")
    config.omnibus.chef_version = "12.3.0" # doesn't seem to cache on :latest
  else
    puts "WARN : You should consider installing vagrant-omnibus with vagrant cachier or you might download chef several times"
  end
end

def download_cookbook(cookbook)
  Dir.mkdir ".chef_dependencies" unless Dir.exist? ".chef_dependencies"
  require 'open-uri'
  unless Dir.exist? ".chef_dependencies/#{cookbook}"
    puts "INFO : downloading #{cookbook} cookbook in .chef_dependencies/"
    File.open(".chef_dependencies/#{cookbook}.tgz", "wb") do |saved_file|
      open("https://supermarket.chef.io/cookbooks/#{cookbook}/download", "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end
    system "tar zxvf .chef_dependencies/#{cookbook}.tgz -C .chef_dependencies"
    FileUtils.rm ".chef_dependencies/#{cookbook}.tgz"
  end
end

Vagrant.configure(2) do |config|   
   
  unless Vagrant.has_plugin?("vagrant-berkshelf")
    puts "WARN : You should consider installing chefdk and vagrant-berkshelf, I'm downloading chef dependencies a bit hackily (means it's dirty)"
    %w(apt).each { |cookbook| download_cookbook cookbook }
  end
   
  # Require the Trigger plugin for Vagrant
  unless Vagrant.has_plugin?('vagrant-triggers')
    # Attempt to install ourself. 
    # Bail out on failure so we don't get stuck in an infinite loop.
    system('vagrant plugin install vagrant-triggers') || exit!
    # Relaunch Vagrant so the new plugin(s) are detected.
    # Exit with the same status code.
    exit system('vagrant', *ARGV)
  end
      
  optimization_by_caching(config)
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = false
  machines.each_with_index do |(hostname, info), index|
     
    config.vm.define hostname do |cfg|
        # Workaround for https://github.com/mitchellh/vagrant/issues/5199
      cfg.trigger.before [:reload, :up], stdout: true do
         SYNCED_FOLDER = ".vagrant/machines/#{hostname}/virtualbox/synced_folders"
        begin
           puts "INFO : Trying to delete folder #{SYNCED_FOLDER}."
           File.delete(SYNCED_FOLDER)
        rescue StandardError => e
           puts "WARN : Could not delete folder #{SYNCED_FOLDER}."
        end
      end  
            
      cfg.vm.provider :virtualbox do |vb, override|
        override.vm.network :private_network, ip: info[:ip]
        override.vm.hostname = hostname
        vb.name = hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem]]
      end
       
      cfg.vm.provision "chef_zero" do |chef|
        chef.provisioning_path = "/tmp/vagrant-chef"
        chef.cookbooks_path = ["cookbooks",".chef_dependencies"]
        chef.roles_path = "roles"
        chef.formatter = "doc" # nice chef convergence ouput
        chef.arguments = "no-listen"
        info[:roles].each do |chef_role|
          chef.add_role chef_role
          chef.json = {
              zookeeper: { id: "#{index}" }, # OK, this is crapy
              vagrant: {ipaddress: info[:ip] } # OK, this is crapy too but vagrant use eth0 and first ipaddress for internal use
          }
        end
      end
    end
  end
end
