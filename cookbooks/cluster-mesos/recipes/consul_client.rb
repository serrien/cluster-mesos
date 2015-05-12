include_recipe 'cluster-mesos::consul_install'
template '/etc/consul.d/client/config.json' do
  source 'consul_client_config.json.erb'
end
template '/etc/init/consul.conf' do
  source 'consul_client.conf.erb'
  mode '555'
  owner 'root'
  group 'root'
end
service 'consul' do
  action :start
end