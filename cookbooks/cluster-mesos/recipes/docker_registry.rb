include_recipe 'cluster-mesos::docker_install'

execute "docker rm -f registrator; true"
execute "docker run --name registrator -d -v /var/run/docker.sock:/tmp/docker.sock -h #{node['vagrant']['ipaddress']} gliderlabs/registrator consul://#{node['vagrant']['ipaddress']}:8500"
execute "docker rm -f registry; true"
execute "docker run --name registry -d -p 5000:5000 registry:2.0"
