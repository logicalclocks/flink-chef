bash 'kill_running_service_flink' do
    user "root"
    ignore_failure true
    code <<-EOF
      pkill JobManager
      pkill TaskManager
    EOF
end


directory node[:flink][:home] do
  recursive true
  action :delete
  ignore_failure true
end

link node[:flink][:dir] + "/flink" do
  action :delete
  ignore_failure true
end


