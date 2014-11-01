# flink-0.4-hadoop2.tgz
# flink-dist-0.4-hadoop2-yarn-uberjar.jar

default[:flink][:user]         =  node[:hadoop][:user]
default[:flink][:group]        =  node[:hadoop][:group]


default[:flink][:version]       = "0.7.0-incubating-bin-hadoop2-yarn" 
default[:flink][:name]          = "yarn-0.7.0-incubating" 
default[:flink][:dir] 	        = "/srv"
default[:flink][:home]          = "#{default[:flink][:dir]}/flink-#{node[:flink][:name]}"
default[:flink][:url]           = "#{node[:download_url]}/flink-#{node[:flink][:version]}.tgz"

default[:jobmanager][:rpc][:address] = "localhost"
default[:jobmanager][:rpc][:port] = 6123
default[:jobmanager][:heap][:mb] = 256
default[:taskmanager][:heap][:mb] = 512
default[:taskmanager][:numberOfTaskSlots] = -1
default[:parallelization][:degree][:default] = 1
default[:jobmanager][:web][:port] = 8081
default[:webclient][:port] = 8080
default[:taskmanager][:network][:numberOfBuffers] = 2048
