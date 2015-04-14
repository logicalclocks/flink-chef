

# file "#{node[:flink][:conf_dir]}/slaves" do
#     owner node[:flink][:user]
#     action :delete
# end

slaves = ""

node[:flink][:taskmanager][:private_ips].each do |slave|
   slaves += "#{slave}\n"
end

# Default behaviour of attribute "content" is to replace the contents of
# the existing file as long as the new contents have a non-default value.
file "#{node[:flink][:conf_dir]}/slaves" do
  owner node[:flink][:user]
  group node[:hadoop][:group]
  mode '644'
  content slaves.to_s
  action :create_if_missing
end

flink_init "jobmanager" do
  action :start_jobmanager
end
