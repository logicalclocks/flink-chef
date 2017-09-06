libpath = File.expand_path '../../../kagent/libraries', __FILE__

begin
  master_ip = private_recipe_ip("hops","nn")
rescue
  master_ip = private_recipe_ip("hops","nn")
end

remote_file "#{Chef::Config.file_cache_path}/apache.txt" do
  source "https://www.apache.org/licenses/LICENSE-2.0.txt"
end


hops_hdfs_directory "#{Chef::Config.file_cache_path}/apache.txt" do
  action :put_as_superuser
  dest "/user/#{node['flink']['user']}"
  owner node['flink']['user']
  group node['flink']['group']
  mode "775"
end

nn="#{master_ip}:#{node['hops']['nn']['port']}"

 bash 'wordcount-example' do
  user node['flink']['user']
  code <<-EOH
     set -e && set -o pipefail
     cd #{node['flink']['home']}
     # This generates about 100 MB of random data, takes about 30 seconds on my laptop
     # head -c 100000000 /dev/urandom >> examples/dummy.txt
     echo "./bin/flink run -p 1 -j ./examples/WordCount.jar hdfs://#{nn}/user/#{node['flink']['user']}/apache.txt hdfs://#{nn}/user/#{node['flink']['user']}/wordcount-result.txt\n" > README.wordcount
  EOH
 end
