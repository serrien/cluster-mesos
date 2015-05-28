include_recipe 'cluster-mesos::docker_install'
include_recipe 'cluster-mesos::mesos_install'
images = node['mesos']['docker']['images']
images.each do |image|
  docker_image image[:name] do
    registry '192.168.33.201:5000'
    tag image[:tag] unless image[:tag].nil?
    action :pull_if_missing
  end
end


file '/etc/mesos/zk' do
  content "zk://192.168.33.10:2181,192.168.33.11:2181,192.168.33.12:2181/mesos"
  mode "555"
  owner "root"
  group "root"
end
%w(/etc/init/zookeeper.override /etc/init/mesos-master.override).each do |f|
  file f do
    content "manual"
    mode "555"
    owner "root"
    group "root"
  end
end
execute "docker rm -f registrator; true"
execute "docker run --name registrator -d -v /var/run/docker.sock:/tmp/docker.sock -h #{node['vagrant']['ipaddress']} 192.168.33.201:5000/gliderlabs/registrator consul://#{node['vagrant']['ipaddress']}:8500"
%w(/etc/mesos-slave/ip /etc/mesos-slave/hostname).each do |f|
  file f do
    content node['vagrant']['ipaddress']
    mode "555"
    owner "root"
    group "root"
  end
end
file "/etc/mesos-slave/containerizers" do
  content 'docker,mesos'
  mode "555"
  owner "root"
  group "root"
end
file '/etc/mesos-slave/executor_registration_timeout' do
  content '5mins'
  mode "555"
  owner "root"
  group "root"
end
service 'mesos-slave' do
  action :restart
end