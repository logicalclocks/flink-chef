begin
  master_ip = private_recipe_ip("flink","jobmanager")
rescue
# No master is needed for YARN
  master_ip = my_private_ip()
end

include_recipe "java"

group node.apache_hadoop.group do
  action :create
  not_if "getent group #{node.apache_hadoop.group}"
end

user node.flink.user do
  supports :manage_home => true
  action :create
  home "/home/#{node.flink.user}"
  system true
  shell "/bin/bash"
  not_if "getent passwd #{node.flink.user}"
end

group node.apache_hadoop.group do
  action :modify
  members ["#{node.flink.user}"]
  append true
end 

url = node.flink.url
Chef::Log.info "Download URL:  #{url}"

base_filename =  File.basename(node.flink.url)
base_dirname =  File.basename(base_filename, ".tgz")
flink_dirname = "/tmp/#{base_dirname}"
cached_filename = "/tmp/#{base_filename}"

Chef::Log.info "You should find flink binaries in:  #{cached_filename}"

remote_file cached_filename do
#  checksum node.flink.checksum
  source url
  mode 0755
  action :create
end

bash "unpack_flink" do
    user "root"
    code <<-EOF
    tar -xzf #{cached_filename} -C /tmp
    mv /tmp/flink-#{node.flink.version} #{node.flink.dir}
    if [ -L #{node.flink.dir}/flink  ; then
       rm -rf #{node.flink.dir}/flink
    fi
    chown -R #{node.flink.user} #{node.flink.home}
    ln -s #{node.flink.home} #{node.flink.dir}/flink
    chown #{node.flink.user} #{node.flink.dir}/flink
    EOF
    not_if { ::File.exists?( "#{node.flink.home}/bin/jobmanager" ) }
end


file "#{node.flink.home}/conf/flink-conf.yaml" do 
  owner node.flink.user
  action :delete
end


template "#{node.flink.home}/conf/flink-conf.yaml" do
    source "flink-conf.yaml.erb"
    owner node.flink.user
    group node.flink.group
    mode 0775
  variables({
              :jobmanager_ip => master_ip
            })
end


file "#{node.flink.home}/flink.jar" do
  action :delete
  force_unlink true  
end

 link "#{node.flink.home}/flink.jar" do
   owner node.flink.user
   group node.flink.group
   to "#{node.flink.home}/lib/flink-dist_" + node.flink.scala_version + "-#{node.flink.version}.jar"
 end

