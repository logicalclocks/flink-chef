include_recipe "flink::default"

file "#{node.flink.conf_dir}/slaves" do
   owner node.flink.user
   action :delete
end

slaves = node.flink.taskmanager.private_ips.join("\n")
slaves += "\n"

# Default behaviour of attribute "content" is to replace the contents of
# the existing file as long as the new contents have a non-default value.
file "#{node.flink.conf_dir}/slaves" do
  owner node.flink.user
  group node.flink.group
  mode '644'
  content slaves.to_s
  action :create
end

service "jobmanager" do
  supports :restart => true, :stop => true, :start => true, :status => true
  action :nothing
end

template "/etc/init.d/jobmanager" do
  source "jobmanager.erb"
  owner node.flink.user
  group node.flink.group
  mode 0754
  variables({
              :flavor => "#{node.flink.mode}"
            })
  notifies :enable, resources(:service => "jobmanager")
  notifies :start, resources(:service => "jobmanager"), :immediately
  notifies :restart, resources(:service => "jobmanager")
end


homedir = node.flink.user.eql?("root") ? "/root" : "/home/#{node.flink.user}"

#
# Enables the taskmanagers to be started/stopped remotely from the jobmanager by
# adding the jobmanager's public ssh key to the .ssh/authorized_keys file for each taskmanager
#

kagent_keys "#{homedir}" do
  cb_user node.flink.user
  cb_group node.flink.group
  action :generate  
end  

kagent_keys "#{homedir}" do
  cb_user node.flink.user
  cb_group node.flink.group
  cb_name "flink"
  cb_recipe "jobmanager"  
  action :return_publickey
end  
