include_recipe "flink::default"

# file "#{node[:flink][:conf_dir]}/slaves" do
#     owner node[:flink][:user]
#     action :delete
# end

slaves = node[:flink][:taskmanager][:private_ips].join("\n")

#node[:flink][:taskmanager][:private_ips].each do |slave|
#   slaves += "#{slave}\n"
#end

# Default behaviour of attribute "content" is to replace the contents of
# the existing file as long as the new contents have a non-default value.
file "#{node[:flink][:conf_dir]}/slaves" do
  owner node[:flink][:user]
  group node[:hadoop][:group]
  mode '644'
  content slaves.to_s
  action :create
end

# flink_init "jobmanager" do
#   action :start_jobmanager
# end


service "jobmanager" do
  supports :restart => true, :stop => true, :start => true, :status => true
  action :nothing
end

template "/etc/init.d/jobmanager" do
  source "jobmanager.erb"
  owner node[:flink][:user]
  group node[:hadoop][:group]
  mode 0754
#  notifies :enable, resources(:service => "jobmanager")
  notifies :restart, resources(:service => "jobmanager"), :immediately
end

hadoop_hdfs_directory "/User/#{node[:flink][:user]}" do
  action :create
  owner node[:flink][:user]
  mode "1775"
end
