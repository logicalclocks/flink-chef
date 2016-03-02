include_recipe "flink::default"

service "taskmanager" do
  supports :restart => true, :stop => true, :start => true, :status => true
  action :nothing
end

template "/etc/init.d/taskmanager" do
  source "taskmanager.erb"
  owner node.flink.user
  group node.flink.group
  mode 0754
  notifies :enable, resources(:service => "taskmanager")
  notifies :restart, resources(:service => "taskmanager")
end

homedir = node.flink.user.eql?("root") ? "/root" : "/home/#{node.flink.user}"

#
# Enables the taskmanagers to be started/stopped remotely from the jobmanager by
# adding its public ssh key to the .ssh/authorized_keys file for each taskmanager
#
kagent_keys "#{homedir}" do
  cb_user "#{node.flink.user}"
  cb_group "#{node.flink.group}"
  cb_name "flink"
  cb_recipe "jobmanager"  
  action :get_publickey
end  


