apt_repository 'mesos' do
  uri "http://repos.mesosphere.io/#{node['platform']}"
  components ['main']
  distribution node['lsb']['codename']
  key 'E56151BF'
  keyserver 'keyserver.ubuntu.com'
  action :add
  deb_src false
end
package 'mesos'