hadoop_hdfs_directory "#{node.apache_hadoop.hdfs.user_home}/#{node.flink.user}" do
  action :create_as_superuser
  owner node.flink.user
  group node.flink.group
  mode "1775"
end

hadoop_hdfs_directory "#{node.apache_hadoop.hdfs.user_home}/#{node.flink.user}/checkpoints" do
  action :create_as_superuser
  owner node.flink.user
  group node.flink.group
  mode "1775"
end
