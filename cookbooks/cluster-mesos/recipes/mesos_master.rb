include_recipe 'cluster-mesos::docker_install'
include_recipe 'cluster-mesos::mesos_install'
package 'marathon'
package 'chronos'
%w(/etc/mesos/ /etc/marathon/conf/ /etc/mesos-master/ /var/zookeeper/).each do |d|
  directory d do
    recursive true
    mode "777"
    owner "root"
    group "root"
  end
end
%w(/etc/mesos/zk /etc/marathon/conf/master).each do |f|
  file f do
    content "zk://192.168.33.10:2181,192.168.33.11:2181,192.168.33.12:2181/mesos"
    mode "555"
    owner "root"
    group "root"
  end
end
template "/etc/zookeeper/conf/zoo.cfg" do
  source "zoo.cfg.erb"
  mode "555"
  owner "root"
  group "root"
end
file "/etc/mesos-master/quorum" do
  content "2"
  mode "555"
  owner "root"
  group "root"
end

file "/etc/marathon/conf/zk" do
  content "zk://192.168.33.10:2181,192.168.33.11:2181,192.168.33.12:2181/marathon"
  mode "555"
  owner "root"
  group "root"
end
file "/etc/init/mesos-slave.override" do
  content "manual"
  mode "555"
  owner "root"
  group "root"
end
%w(/etc/zookeeper/conf/myid /var/zookeeper/myid).each do |f|
  file f do
    content node['zookeeper']['id']
    mode "555"
    owner "root"
    group "root"
  end
end
%w(/etc/chronos/conf/hostname /etc/mesos-master/ip /etc/mesos-master/hostname /etc/marathon/conf/hostname).each do |f|
  file f do
    content node['vagrant']['ipaddress']
    mode "555"
    owner "root"
    group "root"
  end
end
file '/etc/marathon/conf/task_launch_timeout' do
  content '300000'
  mode "555"
  owner "root"
  group "root"
end
%w(zookeeper mesos-master marathon chronos).each do |s|
  service s do
    action :restart
  end
end