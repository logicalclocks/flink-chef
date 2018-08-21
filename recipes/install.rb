begin
  master_ip = private_recipe_ip("flink","jobmanager")
rescue
# No master is needed for YARN
  master_ip = my_private_ip()
end

include_recipe "java"

group node['flink']['group'] do
  action :create
  not_if "getent group #{node['flink']['group']}"
end

user node['flink']['user'] do
  action :create
  gid node['flink']['group']
  system true
  shell "/bin/false"
  not_if "getent passwd #{node['flink']['user']}"
end

group node['hops']['group'] do
  action :modify
  members ["#{node['flink']['user']}"]
  append true
end 

url = node['flink']['url']
Chef::Log.info "Download URL:  #{url}"

base_filename =  File.basename(node['flink']['url'])
base_dirname =  File.basename(base_filename, ".tgz")
flink_dirname = "#{Chef::Config['file_cache_path']}/#{base_dirname}"
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
  group node['flink']['group']
  mode "755"
  action :create
  not_if { File.directory?("#{node['flink']['dir']}") }
end


bash "unpack_flink" do
    user "root"
    code <<-EOF
    tar -xzf #{cached_filename} -C #{Chef::Config['file_cache_path']}
    mv #{Chef::Config['file_cache_path']}/flink-#{node['flink']['version']} #{node['flink']['dir']}
    if [ -L #{node['flink']['dir']}/flink  ; then
       rm -rf #{node['flink']['dir']}/flink
    fi
    chown -R #{node['flink']['user']}:#{node['flink']['group']} #{node['flink']['home']}
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


template "#{node['flink']['home']}/conf/flink-conf.yaml" do
    source "flink-conf.yaml.erb"
    owner node['flink']['user']
    group node['flink']['group']
    mode 0775
  variables({
              :jobmanager_ip => master_ip
            })
end


 link "#{node['flink']['home']}/flink.jar" do
   owner node['flink']['user']
   group node['flink']['group']
   to "#{node['flink']['home']}/lib/flink-dist_" + node['flink']['scala_version'] + "-#{node['flink']['version']}.jar"
 end


#connector=File.basename(node['flink']['connector']['url'])
 
#remote_file "#{node['flink']['home']}/lib/#{connector}" do
#  source node['flink']['connector']['url']
#  owner node['flink']['user']
#  group node['flink']['group']
#  mode 0644
#  action :create
#end
   

#kafkaUtil=File.basename(node['hops']['kafka_util']['url'])
 
#remote_file "#{node['flink']['home']}/lib/#{kafkaUtil}" do
#  source node['hops']['kafka_util']['url']
#  owner node['flink']['user']
#  group node['flink']['group']
#  mode 0644
#  action :create
#end
   
