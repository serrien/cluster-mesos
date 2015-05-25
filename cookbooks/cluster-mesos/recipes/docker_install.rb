#source : http://get.docker.io/ubuntu
apt_repository 'docker' do
  uri 'https://get.docker.io/ubuntu'
  components ['main']
  distribution 'docker'
  key '36A1D7869245C8950F966E92D8576A8BA88D21E9'
  keyserver 'hkp://p80.pool.sks-keyservers.net:80'
  action :add
  deb_src false
end
package 'lxc-docker'
template '/etc/default/docker' do
  source 'etc_default_docker.erb'
  mode '644'
  owner 'root'
  group 'root'
  notifies :restart, "service[docker]", :immediately
end
service 'docker' do
  action :nothing
end