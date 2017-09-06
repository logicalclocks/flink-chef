
home = node['hops']['hdfs']['user_home']

hops_hdfs_directory "#{home}/#{node['flink']['user']}" do
  action :create_as_superuser
  owner node['flink']['user']
  group node['flink']['group']
  mode "1777"
end

hops_hdfs_directory "#{home}/#{node['flink']['user']}/checkpoints" do
  action :create_as_superuser
  owner node['flink']['user']
  group node['flink']['group']
  mode "1777"
end

hops_hdfs_directory "#{node['flink']['home']}/flink.jar" do
  action :put_as_superuser
  owner node['flink']['user']
  group node['hops']['group']
  mode "1755"
  dest "#{home}/#{node['flink']['user']}/flink.jar"
end

hops_hdfs_directory "#{node['flink']['home']}/conf/flink-conf.yaml" do
  action :put_as_superuser
  owner node['flink']['user']
  group node['hops']['group']
  mode "1775"
  dest "#{home}/#{node['flink']['user']}/flink-conf.yaml"
end
