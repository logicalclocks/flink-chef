action :start_jobmanager do

  Chef::Log.info "Starting a jobmanager."

  bash "starting-jobmanager-#{new_resource.name}" do
    user node.flink.user
    group node.flink.group
    code <<-EOF
     #{node.flink.home}/bin/jobmanager.sh start cluster
     #{node.flink.home}/bin/webclient.sh start
    EOF
  end
end



action :start_taskmanager do
Chef::Log.info "Starting a taskmanager."

  bash "starting-taskmanager-#{new_resource.name}" do
    user node.flink.user
    group node.flink.group
    code <<-EOF
     #{node.flink.home}/bin/taskmanager.sh start
     #{node.flink.home}/bin/webclient.sh start
    EOF
  end

end
