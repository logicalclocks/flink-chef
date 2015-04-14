action :start_jobmanager do

  Chef::Log.info "Starting a jobmanager."

  bash "starting-jobmanager-#{new_resource.name}" do
    user node[:hdfs][:user]
    code <<-EOF
     set -e
     #{node[:flink][:home]}/bin/start-cluster.sh
    EOF
  end

end



action :start_taskmanager do
Chef::Log.info "Starting a taskmanager."

  bash "starting-taskmanager-#{new_resource.name}" do
    user node[:hdfs][:user]
    code <<-EOF
     set -e
     #{node[:flink][:home]}/bin/taskmanager.sh start
    EOF
  end

end
