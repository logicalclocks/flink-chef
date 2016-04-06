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



# Add the jobmanager hosts' public key, so that it can start/stop this node using passwordless ssh.
# Dont append if the public key is already in the authorized_keys or is empty
# sshkey=node[:flink][:jobmanager][:public_key]
# bash "add_jobmgr_public_key" do
#  user node[:flink][:user]
#  code <<-EOF
#       mkdir #{homedir}/.ssh
#       echo "#{sshkey}" >> #{homedir}/.ssh/authorized_keys
#       touch #{homedir}/.ssh/.jobmgr_key_authorized
#   EOF
#  not_if { ::File.exists?( "#{homedir}/.ssh/.jobmgr_key_authorized" || "#{sshkey}".empty? ) }
# end


bash "chgrp-flink-installation" do
 user "root"
  code <<-EOF
  chown -R #{node.flink.user}:hadoop #{node.flink.home}/
  EOF
end

