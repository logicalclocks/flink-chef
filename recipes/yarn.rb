
home = node['hops']['hdfs']['user_home']

hops_hdfs_directory "#{home}/#{node['flink']['user']}" do
  action :create_as_superuser
  owner node['flink']['user']
  group node['hops']['group']
  mode "1777"
end

ruby_block "hadoop_glob" do
  block do
    Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
    node.default['hadoop_glob'] = shell_out("#{node['hops']['bin_dir']}/hadoop classpath --glob  | tr -d '\n'").stdout
  end
  action :create
end

template "#{node['flink']['conf_dir']}/sdk_worker.sh" do
    source "sdk_worker.sh.erb"
    owner node['flink']['user']
    group node['hops']['group']
    mode 0755
    variables({
      :hadoop_glob=> lazy { node['hadoop_glob'] }
    })
end

