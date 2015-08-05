action :return_publickey do
 homedir = "#{new_resource.homedir}"
 contents = ::IO.read("#{homedir}/.ssh/id_rsa.pub")
 Chef::Log.info "Public key read is: #{contents}"
 node.default[:flink][:jobmanager][:public_key] = "#{contents}"

# This works for chef-solo - we are executing this recipe.rb file.
recipeName = "#{__FILE__}".gsub(/.*\//, "")
recipeName = "#{recipeName}".gsub(/\.rb/, "")
 
kagent_param "/tmp" do
  executing_cookbook "flink"
  executing_recipe  "jobmanager"
  cookbook "flink"
  recipe "jobmanager"
  param "public_key"
  value  node[:flink][:jobmanager][:public_key]
end

end
