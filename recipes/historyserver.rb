group node['kagent']['certs_group'] do
  action :modify
  members ["#{node['flink']['user']}"]
  append true
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end

completed_jobs_dir = "#{node['flink']['historyserver']['remote_dir']}"

hops_hdfs_directory completed_jobs_dir do
    action :create_as_superuser
    owner node['flink']['user']
    group node['hops']['group']
    mode "1733"
end


deps = ""
if exists_local("hops", "nn")
  deps = "namenode.service"
end
service_name="flinkhistoryserver"

service service_name do
    provider Chef::Provider::Service::Systemd
    supports :restart => true, :stop => true, :start => true, :status => true
    action :nothing
  end

case node['platform_family']
when "rhel"
  systemd_script = "/usr/lib/systemd/system/#{service_name}.service"
else
  systemd_script = "/lib/systemd/system/#{service_name}.service"
end

ruby_block "hadoop_glob" do
  block do
    Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
    node.default['hadoop_glob'] = shell_out("#{node['hops']['bin_dir']}/hadoop classpath --glob  | tr -d '\n'").stdout
  end
  action :create
end

template node['flink']['historyserver']['environment'] do
    source "historyserver.env.erb"
    owner node['flink']['user']
    group node['hops']['group']
    mode 0750
    variables({
      :hadoop_glob=> lazy { node['hadoop_glob'] }
    })
end

template systemd_script do
    source "#{service_name}.service.erb"
    owner "root"
    group "root"
    mode 0754
    variables({
      :deps=> deps
              })
    if node["services"]["enabled"] == "true"
      notifies :enable, resources(:service => service_name)
    end
    notifies :start, resources(:service => service_name), :immediately
  end

service "flinkhistoryservice" do
  provider Chef::Provider::Service::Systemd
  supports :restart => true, :stop => true, :start => true, :status => true
  action :disable
end


kagent_config service_name do
  action :systemd_reload
end

if node['kagent']['enabled'] == "true"
   kagent_config service_name do
     service "HISTORY_SERVERS"
     log_file "#{node['flink']['historyserver']['logs']}/flink-#{node['hops']['hdfs']['user']}-historyserver-0-#{node['hostname']}.log"
   end
end


# Setup cron job for restaring flink history server once a day, after Hopsworks removed orphan jobs from hdfs
# complete-jods dir
cron 'restart_flink_historyserver' do
  command "systemctl restart #{service_name}"
  user "root"
  minute '0'
  hour '1'
  day '*'
  month '*'
end
