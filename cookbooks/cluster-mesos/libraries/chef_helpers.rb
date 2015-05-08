class Chef
  module ClusterMesos
    module Helpers
      def download_and_install(url, checksum_value, target_directory, source_directory = '')
        package = url.split('/')[-1]
        component = package.split('.zip')[-1]
        remote_file "/tmp/#{package}" do
          source url
          mode '0644'
          checksum checksum_value
        end
        directory "/tmp/#{component}" do
          recursive true
        end
        directory target_directory do
          action :create
          recursive true
          mode '775'
          owner 'root'
          group 'root'
        end
        execute "unzip /tmp/#{package} -d /tmp/#{component}"
        execute "chmod 555 /tmp/#{component}*"
        execute "mv /tmp/#{component}#{source_directory}/* #{target_directory}"
        file "/tmp/#{package}" do
          action :delete
        end
        remote_directory "/tmp/#{component}" do
          action :delete
        end
      end
    end
  end
end