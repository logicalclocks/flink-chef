 bash 'wordcount-example' do
  user node[:flink][:user]
  code <<-EOH
        set -e && set -o pipefail

        cd #{node[:flink][:home]}
        wget -O apache-license-v2.txt http://www.apache.org/licenses/LICENSE-2.0.txt
        ./bin/flink run -j ./examples/flink-java-examples-0.7-incubating-WordCount.jar file://#{node[:flink][:home]}/apache-license-v2.txt file://#{node[:flink][:home]}/wordcount-result.txt
  EOH
 end



