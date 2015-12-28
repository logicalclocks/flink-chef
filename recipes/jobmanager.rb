include_recipe "flink::default"

file "#{node[:flink][:conf_dir]}/slaves" do
   owner node[:flink][:user]
   action :delete
end

slaves = node[:flink][:taskmanager][:private_ips].join("\n")
slaves += "\n"

# Default behaviour of attribute "content" is to replace the contents of
# the existing file as long as the new contents have a non-default value.
file "#{node[:flink][:conf_dir]}/slaves" do
  owner node[:flink][:user]
  group node[:flink][:group]
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
  owner node[:flink][:user]
  group node[:flink][:group]
  mode 0754
  variables({
              :flavor => "#{node[:flink][:mode]}"
            })
  notifies :enable, resources(:service => "jobmanager")
  notifies :restart, resources(:service => "jobmanager"), :immediately
end


homedir = node[:flink][:user].eql?("root") ? "/root" : "/home/#{node[:flink][:user]}"

kagent_keys "#{homedir}" do
  cb_user node[:flink][:user]
  cb_group node[:flink][:group]
  action :generate  
end  

kagent_keys "#{homedir}" do
  cb_user node[:flink][:user]
  cb_group node[:flink][:group]
  cb_name "flink"
  cb_recipe "jobmanager"  
  action :return_publickey
end  
