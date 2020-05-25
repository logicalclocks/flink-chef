include_recipe "java"

group node['hops']['group'] do
  gid node['hops']['group_id']
  action :create
  not_if "getent group #{node['hops']['group']}"
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end

user node['hops']['hdfs']['user'] do
  home "/home/#{node['hops']['hdfs']['user']}"
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

directory node['flink']['historyserver']['local_dir']  do
  owner node['flink']['user']
  group node['hops']['group']
  mode "700"
  action :create
  not_if { File.directory?("#{node['flink']['historyserver']['local_dir']}") }
end

directory node['flink']['historyserver']['logs']  do
  owner node['flink']['user']
  group node['hops']['group']
  mode "700"
  action :create
  not_if { File.directory?("#{node['flink']['historyserver']['logs']}") }
end

directory node['flink']['historyserver']['tmp']  do
  owner node['flink']['user']
  group node['hops']['group']
  mode "700"
  action :create
  not_if { File.directory?("#{node['flink']['historyserver']['tmp']}") }
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

remote_file "#{node['flink']['conf_dir']}/boot" do
    source "#{node['flink']['beam_boot']['url']}"
    owner node['flink']['user']
    group node['hops']['group']
    mode "0755"
    action :create
end

remote_file "#{node['flink']['conf_dir']}/#{node['flink']['beamjobserver_name']}" do
  source "#{node['flink']['beamjobserver_jar']['url']}"
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
