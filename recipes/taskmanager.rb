include_recipe "flink::default"

# flink_init "taskmanager" do
#   action :start_taskmanager
# end

service "taskmanager" do
  supports :restart => true, :stop => true, :start => true, :status => true
  action :nothing
end

template "/etc/init.d/taskmanager" do
  source "taskmanager.erb"
  owner node[:flink][:user]
  group node[:hadoop][:group]
  mode 0754
#  notifies :enable, resources(:service => "taskmanager")
  notifies :restart, resources(:service => "taskmanager")
end
