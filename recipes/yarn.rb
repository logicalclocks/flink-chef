
home = node.apache_hadoop.hdfs.user_home

apache_hadoop_hdfs_directory "#{home}/#{node.flink.user}" do
  action :create_as_superuser
  owner node.flink.user
  group node.flink.group
  mode "1775"
end

apache_hadoop_hdfs_directory "#{home}/#{node.flink.user}/checkpoints" do
  action :create_as_superuser
  owner node.flink.user
  group node.flink.group
  mode "1775"
end

apache_hadoop_hdfs_directory "#{node.flink.home}/flink.jar" do
  action :put_as_superuser
  owner node.flink.user
  group node.apache_hadoop.group
  mode "1755"
  dest "#{home}/#{node.flink.user}/flink.jar"
end
