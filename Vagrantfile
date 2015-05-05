# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.




mesos_masters = {
  "mesos-master1" => { :ip => "192.168.33.10", :mem => 512 },
  "mesos-master2" => { :ip => "192.168.33.11", :mem => 512 },
  "mesos-master3" => { :ip => "192.168.33.12", :mem => 512 }
}

mesos_slaves = {
  "mesos-slave1"  => { :ip => "192.168.33.101", :mem => 512 },
  "mesos-slave2"  => { :ip => "192.168.33.102", :mem => 512 }
}

consul = {
  "consul"  => { :ip => "192.168.33.201", :mem => 512 }
}

$commonscript = <<SCRIPT
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | \
  sudo tee /etc/apt/sources.list.d/mesosphere.list
sudo apt-get -y update
 
SCRIPT


$masterscript = <<SCRIPT
sudo apt-get -y install mesos marathon chronos
echo "zk://192.168.33.10:2181,192.168.33.12:2181,192.168.33.13:2181/mesos" | sudo tee /etc/mesos/zk
echo "dataDir=/var/zookeeper" | sudo tee /etc/zookeeper/conf/zoo.cfg
echo "clientPort=2181" | sudo tee -a /etc/zookeeper/conf/zoo.cfg
echo "initLimit=5" | sudo tee -a /etc/zookeeper/conf/zoo.cfg
echo "syncLimit=2" | sudo tee -a /etc/zookeeper/conf/zoo.cfg
echo "tickTime=2000" | sudo tee -a /etc/zookeeper/conf/zoo.cfg
echo "server.1=192.168.33.10:2888:3888" | sudo tee -a /etc/zookeeper/conf/zoo.cfg
echo "server.2=192.168.33.11:2888:3888" | sudo tee -a /etc/zookeeper/conf/zoo.cfg
echo "server.3=192.168.33.12:2888:3888" | sudo tee -a /etc/zookeeper/conf/zoo.cfg

echo "2" | sudo tee /etc/mesos-master/quorum

sudo mkdir -p /etc/marathon/conf
echo "zk://192.168.33.10:2181,192.168.33.12:2181,192.168.33.13:2181/marathon " | sudo tee /etc/marathon/conf/zk

sudo stop mesos-slave
echo manual | sudo tee /etc/init/mesos-slave.override
SCRIPT


$slavescript = <<SCRIPT
sudo apt-get -y install mesos
echo "zk://192.168.33.10:2181,192.168.33.12:2181,192.168.33.13:2181/mesos" | sudo tee /etc/mesos/zk

sudo stop zookeeper
echo manual | sudo tee /etc/init/zookeeper.override

sudo stop mesos-master
echo manual | sudo tee /etc/init/mesos-master.override
SCRIPT

$consulscript = <<SCRIPT
apt-get install unzip
cd /usr/local/bin
sudo rm consul
sudo wget https://dl.bintray.com/mitchellh/consul/0.5.0_linux_amd64.zip
sudo unzip *.zip
sudo rm *.zip
sudo mkdir -p /etc/consul.d/{bootstrap,server,client}
sudo rm -rf /var/consul
sudo mkdir -p /var/consul/data
cd /var/consul
sudo wget https://dl.bintray.com/mitchellh/consul/0.5.0_web_ui.zip
sudo unzip *.zip
sudo rm *.zip
sudo mv /var/consul/dist /var/consul/ui
SCRIPT


Vagrant.configure(2) do |config|
   
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision "docker"
  #config.vm.provision "shell", inline: $commonscript
   
  mesos_masters.each_with_index do |(hostname, info), index|
    config.vm.define hostname do |cfg|

      cfg.vm.provider :virtualbox do |vb, override|
        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.hostname = hostname

        vb.name = hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem] ]
      end # end cfg.vm.provider
     
     config.vm.provision "shell" do |s|
       s.inline = "echo $1"
       s.args   = "'hello, world!'"
     end
      cfg.vm.provision "shell", inline: $masterscript
      cfg.vm.provision "shell", inline: "echo #{index+1} | sudo tee /etc/zookeeper/conf/myid"
      cfg.vm.provision "shell", inline: "sudo rm -rf /var/zookeeper"
      cfg.vm.provision "shell", inline: "sudo mkdir -p /var/zookeeper"
      cfg.vm.provision "shell", inline: "sudo chmod a+w /var/zookeeper"
      cfg.vm.provision "shell", inline: "sudo cp /etc/zookeeper/conf/myid /var/zookeeper"
      cfg.vm.provision "shell", inline: "echo #{info[:ip]} | sudo tee /etc/mesos-master/ip"
      cfg.vm.provision "shell", inline: "sudo cp /etc/mesos-master/ip /etc/mesos-master/hostname"
      cfg.vm.provision "shell", inline: "sudo cp /etc/mesos-master/hostname /etc/marathon/conf"
      cfg.vm.provision "shell", inline: "sudo cp /etc/mesos/zk /etc/marathon/conf/master"
      cfg.vm.provision "shell", inline: "echo 300000 | sudo tee /etc/marathon/conf/task_launch_timeout"
      cfg.vm.provision "shell", inline: "sudo service zookeeper restart"
      cfg.vm.provision "shell", inline: "sudo service mesos-master restart"
      cfg.vm.provision "shell", inline: "sudo service marathon restart"
      cfg.vm.provision "shell", inline: "sudo service chronos restart"

      
    end # end config
  end #end mesos_masters

  mesos_slaves.each_with_index do |(hostname, info), index|
    config.vm.define hostname do |cfg|

      cfg.vm.provider :virtualbox do |vb, override|
        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.hostname = hostname

        vb.name = hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem] ]
      end # end cfg.vm.provider
     
      cfg.vm.provision "shell", inline: $slavescript
      cfg.vm.provision "shell", inline: "echo #{info[:ip]} | sudo tee /etc/mesos-slave/ip"
      cfg.vm.provision "shell", inline: "sudo cp /etc/mesos-slave/ip /etc/mesos-slave/hostname"
      cfg.vm.provision "shell", inline: "echo 'docker,mesos' | sudo tee /etc/mesos-slave/containerizers"
      cfg.vm.provision "shell", inline: "echo '5mins' | sudo tee  /etc/mesos-slave/executor_registration_timeout"
      cfg.vm.provision "shell", inline: "sudo service mesos-slave restart"

#cfg.vm.provision "shell", inline: "consul agent -data-dir /tmp/consul -client #{info[:ip]} -ui-dir /home/your_user/dir -join #{consul[0][:ip]}"
    end # end config
  end #end mesos_slaves

consul.each_with_index do |(hostname, info), index|
    config.vm.define hostname do |cfg|

      cfg.vm.provider :virtualbox do |vb, override|
        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.hostname = hostname

        vb.name = hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem] ]
      end # end cfg.vm.provider
     
      cfg.vm.provision "shell", inline: $consulscript
      
      cfg.vm.provision "shell", inline: "echo '{\"datacenter\": \"local\", \"bootstrap\": true, \"server\": true, \"data_dir\": \"/var/consul/data\", \"ui_dir\": \"/var/consul/ui\", \"client_addr\": \"#{info[:ip]}\"}' | sudo tee /etc/consul.d/bootstrap/config.json"
      cfg.vm.provision "shell", inline: "echo 'description \"Consul server process\"' | sudo tee  /etc/init/consul.conf"
      cfg.vm.provision "shell", inline: "echo 'start on (local-filesystems and net-device-up IFACE=eth0)' | sudo tee -a /etc/init/consul.conf"
      cfg.vm.provision "shell", inline: "echo stop on runlevel [!12345] | sudo tee -a /etc/init/consul.conf"
      cfg.vm.provision "shell", inline: "echo respawn | sudo tee -a /etc/init/consul.conf"
      cfg.vm.provision "shell", inline: "echo exec sudo consul agent -config-dir /etc/consul.d/bootstrap | sudo tee -a /etc/init/consul.conf"

      cfg.vm.provision "shell", inline: "sudo start consul"


    end # end config
  end #end consul
end
