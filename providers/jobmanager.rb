action :return_publickey do
 homedir = "#{new_resource.homedir}"
 contents = ::IO.read("#{homedir}/.ssh/id_rsa.pub")
 Chef::Log.info "Public key read is: #{contents}"
 node.default[:flink][:jobmanager][:public_key] = "#{contents}"

  template "#{homedir}/.ssh/config" do
    source "ssh_config.erb"
    owner node[:flink][:user]
    group node[:flink][:group]
    mode 0600
  end
 
 kagent_param "/tmp" do
   executing_cookbook "flink"
   executing_recipe  "jobmanager"
   cookbook "flink"
   recipe "jobmanager"
   param "public_key"
   value  node[:flink][:jobmanager][:public_key]
 end
end

action :get_publickey do
  homedir = "#{new_resource.homedir}"

  Chef::Log.info "JobMgr public key read is: #{node[:flink][:jobmanager][:public_key]}"
  bash "add_jobmgr_public_key" do
    user node[:flink][:user]
    group node[:flink][:group]
    code <<-EOF
      mkdir #{homedir}/.ssh
      echo "#{node[:flink][:jobmanager][:public_key]}" >> #{homedir}/.ssh/authorized_keys
      touch #{homedir}/.ssh/.jobmgr_key_authorized
  EOF
    not_if { ::File.exists?( "#{homedir}/.ssh/.jobmgr_key_authorized" || "#{node[:flink][:jobmanager][:public_key]}".empty? ) }
  end
end
