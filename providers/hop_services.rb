action :install_stratosphere do

  ini_file = IniFile.load(node[:hop][:services], :comment => ';#')

  if ini_file.has_section?("#{node[:hop][:cluster]}-Stratosphere") then
    Chef::Log.info "Over-writing an existing Stratosphere section in the ini file."
    ini_file.delete_section("#{node[:hop][:cluster]}-Stratosphere")
  end

  ini_file["#{node[:hop][:cluster]}-Stratosphere"] = {
    'cluster' => "#{node[:hop][:cluster]}",
    'service'  => "#{node[:stratosphere][:service]}",
    'command-stratosphere-shell' => "#{node[:stratosphere][:home]}/bin/stratosphere-shell",
    'command-stratosphere-class' => "#{node[:stratosphere][:home]}/bin/stratosphere-class",
    'command-stratosphere-class-env' => "STRATOSPHERE_JAR=#{node[:stratosphere][:home]}/assembly/target/scala-#{node[:scala][:version]}/stratosphere-assembly-#{node[:stratosphere][:version]}-hadoop#{node[:hadoop][:version]}.jar"
  }

  ini_file.save
  Chef::Log.info "Saved an updated copy of services file at the hopagent."
end
