daemons = %w{JobManager TaskManager}
daemons.each { |d| 

  bash 'kill_running_service_#{d}' do
    user "root"
    ignore_failure true
    code <<-EOF
      service stop #{d}
      systemctl stop #{d}
      pkill -9 #{d}
    EOF
  end

  file "/etc/init.d/#{d}" do
    action :delete
    ignore_failure true
  end
  
  file "/usr/lib/systemd/system/#{d}.service" do
    action :delete
    ignore_failure true
  end
  file "/lib/systemd/system/#{d}.service" do
    action :delete
    ignore_failure true
  end
}

directory node[:flink][:home] do
  recursive true
  action :delete
  ignore_failure true
end

link node[:flink][:dir] + "/flink" do
  action :delete
  ignore_failure true
end


