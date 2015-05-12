::Chef::Recipe.send(:include, Chef::ClusterMesos::Helpers)

package "unzip"
%w(/etc/consul.d/ /etc/consul.d/bootstrap /etc/consul.d/server /etc/consul.d/client /var/consul/ /var/consul/data).each do |dir|
  directory dir do
    recursive true
    mode '777'
    owner 'root'
    group 'root'
  end
end
unless File.exist? '/usr/local/bin/consul' # crapy : should use manifest file pattern instead
  download_and_install 'https://dl.bintray.com/mitchellh/consul/0.5.0_linux_amd64.zip', '161f2a8803e31550bd92a00e95a3a517aa949714c19d3124c46e56cfdc97b088', '/usr/local/bin', ''
end