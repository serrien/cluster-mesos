::Chef::Recipe.send(:include, Chef::ClusterMesos::Helpers)

include_recipe 'cluster-mesos::consul_install'
template '/etc/consul.d/bootstrap/config.json' do
  source 'consul_bootstrap_config.json.erb'
  mode "555"
  owner "root"
  group "root"
end
template '/etc/init/consul.conf' do
  source 'consul_bootstrap.conf.erb'
  mode '555'
  owner 'root'
  group 'root'
end
service 'consul' do
  action :start
end
unless File.exist? '/var/consul/ui/index.html' # crapy : should use manifest file pattern instead
  download_and_install 'https://dl.bintray.com/mitchellh/consul/0.5.0_web_ui.zip', '0081d08be9c0b1172939e92af5a7cf9ba4f90e54fae24a353299503b24bb8be9', '/var/consul/ui', '/dist'
end