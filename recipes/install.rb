
# directory node[:flink][:home] do
#   owner node[:flink][:user]
#   group node[:flink][:user]
#   mode "755"
#   action :create
#   recursive true
# end


    ark "flink" do
      url node[:flink][:url]
      version node[:flink][:version]
      path node[:flink][:home]
      home_dir "#{node[:flink][:dir]}/flink"
 #     checksum  "#{node[:flink][:checksum]}"
      append_env_path true
      owner "#{node[:flink][:user]}"
    end


# package_url = node[:flink][:url]
# base_package_filename = File.basename(package_url)
# cached_package_filename = "#{Chef::Config[:file_cache_path]}/#{base_package_filename}"

# remote_file cached_package_filename do
#   source package_url
#   owner "#{node[:flink][:user]}"
#   mode "0644"
#   action :create_if_missing
# end

#  bash 'extract-flink' do
#    user "root"
#          code <<-EOH
#   set -e && set -o pipefail
#   tar xfz #{cached_package_filename} -C #{node[:flink][:dir]}
#   chown -R #{node[:flink][:user]} #{node[:flink][:home]}
#   rm #{node[:flink][:home]}/conf/flink-conf.yaml
#   touch #{node[:flink][:home]}/.flink_extracted_#{node[:flink][:version]}
#          EOH
#       not_if { ::File.exists?( "#{node[:flink][:home]}/.flink_extracted_#{node[:flink][:version]}" ) }
#  end

template "#{node[:flink][:home]}/conf/flink-conf.yaml" do
    source "flink-conf.yaml.erb"
    owner node[:flink][:user]
    group node[:flink][:user]
    mode 0775
end

# link "#{node[:flink][:dir]}/flink" do
#   to node[:flink][:home]
# end
