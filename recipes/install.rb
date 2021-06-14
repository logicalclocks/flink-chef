include_recipe "java"

group node['hops']['group'] do
  gid node['hops']['group_id']
  action :create
  not_if "getent group #{node['hops']['group']}"
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end

user node['hops']['hdfs']['user'] do
  home node['hops']['hdfs']['user-home']
  gid node['hops']['group']
  system true
  shell "/bin/bash"
  manage_home true
  action :create
  not_if "getent passwd #{node['hops']['hdfs']['user']}"
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end

group node['hops']['hdfs']['user'] do
  action :create
  not_if "getent group #{node['hops']['hdfs']['user']}"
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end

user node['flink']['user'] do
  action :create
  gid node['hops']['group']
  manage_home true
  home node['flink']['user-home']
  system true
  shell "/bin/false"
  not_if "getent passwd #{node['flink']['user']}"
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end

group node['hops']['group'] do
  action :modify
  members ["#{node['flink']['user']}"]
  append true
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end 

group node["kagent"]["certs_group"] do
  action :manage
  append true
  excluded_members node['flink']['user']
  not_if { node['install']['external_users'].casecmp("true") == 0 }
  only_if { conda_helpers.is_upgrade }
end

url = node['flink']['url']
Chef::Log.info "Download URL:  #{url}"

base_filename =  File.basename(node['flink']['url'])
cached_filename = "#{Chef::Config['file_cache_path']}/#{base_filename}"

Chef::Log.info "You should find flink binaries in:  #{cached_filename}"

remote_file cached_filename do
#  checksum node['flink']['checksum']
  source url
  mode 0755
  action :create
end

directory node['flink']['dir']  do
  owner node['flink']['user']
  group node['hops']['group']
  mode "755"
  action :create
  not_if { File.directory?("#{node['flink']['dir']}") }
end

directory node['data']['dir'] do
  owner 'root'
  group 'root'
  mode '0775'
  action :create
  not_if { ::File.directory?(node['data']['dir']) }
end

directory node['flink']['historyserver']['local_dir']  do
  owner node['flink']['user']
  group node['hops']['group']
  mode "700"
  action :create
  not_if { File.directory?("#{node['flink']['historyserver']['local_dir']}") }
end

directory node['flink_hs']['data_volume']['logs_dir'] do
  owner node['flink']['user']
  group node['hops']['group']
  mode '0700'
  recursive true
end

bash 'Move Flink history server logs to data volume' do
  user 'root'
  code <<-EOH
    set -e
    mv -f #{node['flink']['historyserver']['logs']}/* #{node['flink_hs']['data_volume']['logs_dir']}
    rm -rf #{node['flink']['historyserver']['logs']}
  EOH
  only_if { conda_helpers.is_upgrade }
  only_if { File.directory?(node['flink']['historyserver']['logs'])}
  not_if { File.symlink?(node['flink']['historyserver']['logs'])}
end

link node['flink']['historyserver']['logs'] do
  owner node['flink']['user']
  group node['hops']['group']
  mode '0700'
  to node['flink_hs']['data_volume']['logs_dir']
end

directory node['flink']['historyserver']['tmp']  do
  owner node['flink']['user']
  group node['hops']['group']
  mode "700"
  action :create
  not_if { File.directory?("#{node['flink']['historyserver']['tmp']}") }
end

directory node['flink']['data_volume']['logs_dir'] do
  owner node['flink']['user']
  group node['hops']['group']
  mode '0750'
  recursive true
end

bash "unpack_flink" do
    user "root"
    code <<-EOF
    tar -xzf #{cached_filename} -C #{Chef::Config['file_cache_path']}
    mv #{Chef::Config['file_cache_path']}/flink-#{node['flink']['version']} #{node['flink']['dir']}
    if [ -L #{node['flink']['dir']}/flink  ; then
       rm -rf #{node['flink']['dir']}/flink
    fi
    chown -R #{node['flink']['user']}:#{node['hops']['group']} #{node['flink']['home']}
    chmod 750 #{node['flink']['home']}
    ln -s #{node['flink']['home']} #{node['flink']['dir']}/flink
    chown #{node['flink']['user']} #{node['flink']['dir']}/flink
    EOF
    not_if { ::File.exists?( "#{node['flink']['home']}/bin/jobmanager" ) }
end

# Small hack to create the symlink below. Logs directory already exist in the tarball
directory node['flink']['logs_dir'] do
  recursive true
  action :delete
  not_if { conda_helpers.is_upgrade }
end

bash 'Move Flink logs to data volume' do
  user 'root'
  code <<-EOH
    set -e
    mv -f #{node['flink']['logs_dir']}/* #{node['flink']['data_volume']['logs_dir']}
    rm -rf #{node['flink']['logs_dir']}
  EOH
  only_if { conda_helpers.is_upgrade }
  only_if { File.directory?(node['flink']['logs_dir'])}
  not_if { File.symlink?(node['flink']['logs_dir'])}
end

link node['flink']['logs_dir'] do
  owner node['flink']['user']
  group node['hops']['group']
  mode '0750'
  to node['flink']['data_volume']['logs_dir']
end

file "#{node['flink']['home']}/conf/flink-conf.yaml" do 
  owner node['flink']['user']
  action :delete
end


template "#{node['flink']['base_dir']}/conf/flink-conf.yaml" do
    source "flink-conf.yaml.erb"
    owner node['flink']['user']
    group node['hops']['group']
    mode 0775
end

template "#{node['flink']['base_dir']}/conf/log4j.properties" do
    source "log4j.properties.erb"
    owner node['flink']['user']
    group node['hops']['group']
    mode 0644
end

remote_file "#{node['flink']['lib_dir']}/boot" do
    source "#{node['flink']['beam_boot']['url']}"
    owner node['flink']['user']
    group node['hops']['group']
    mode "0755"
    action :create
end

remote_file "#{node['flink']['lib_dir']}/#{node['flink']['beamjobserver_name']}" do
  source "#{node['flink']['beamjobserver_jar']['url']}"
  owner node['flink']['user']
  group node['hops']['group']
  mode "0755"
  action :create
end

remote_file "#{node['flink']['lib_dir']}/#{node['flink']['service_discovery_client']['name']}" do
  source "#{node['flink']['service_discovery_client']['url']}"
  owner node['flink']['user']
  group node['hops']['group']
  mode "0755"
  action :create
end

link "#{node['flink']['home']}/flink.jar" do
    owner node['flink']['user']
    group node['hops']['group']
    to "#{node['flink']['home']}/lib/flink-dist_" + node['flink']['scala_version'] + "-#{node['flink']['version']}.jar"
end
