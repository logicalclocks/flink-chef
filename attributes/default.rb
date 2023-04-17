include_attribute "kagent"
include_attribute "hops"

default['flink']['user']                             = node['install']['user'].empty? ? "flink" : node['install']['user']
default['flink']['user_id']                          = '1510'
default['flink']['user-home']                        = "/home/#{node['flink']['user']}"

default['flink']['version_base']                     = "1.17"
default['flink']['version_bugfix']                   = "0.0"
default['flink']['version']                          = node['flink']['version_base'] + "." + node['flink']['version_bugfix']

default['flink']['dir']                              = node['install']['dir'].empty? ? "/srv" : node['install']['dir']
default['flink']['base_dir']                         = "#{node['flink']['dir']}/flink"
default['flink']['home']                             = "#{node['flink']['dir']}/flink-#{node['flink']['version']}"
default['flink']['url']                              = node['download_url'] + "/flink-" + node['flink']['version'] + "-bin" + ".tgz"
default['flink']['conf_dir']                         = "#{node['flink']['base_dir']}/conf"
default['flink']['lib_dir']                          = "#{node['flink']['base_dir']}/lib"
default['flink']['logs_dir']                         = "#{node['flink']['base_dir']}/log"

# Data volume directories
default['flink']['data_volume']['root_dir']          = "#{node['data']['dir']}/flink"
default['flink']['data_volume']['logs_dir']          = "#{node['flink']['data_volume']['root_dir']}/log"
default['flink_hs']['data_volume']['root_dir']       = "#{node['data']['dir']}/flinkhistoryserver"
default['flink_hs']['data_volume']['logs_dir']       = "#{node['flink_hs']['data_volume']['root_dir']}/logs"

default['flink']['historyserver']['local_dir']       = "#{node['flink']['dir']}/flinkhistoryserver"
default['flink']['historyserver']['remote_dir']      = "#{node['hops']['hdfs']['user_home']}/#{node['flink']['user']}/completed-jobs"
default['flink']['historyserver']['logs']            = "#{node['flink']['historyserver']['local_dir']}/logs"
default['flink']['historyserver']['tmp']             = "#{node['flink']['historyserver']['local_dir']}/tmp"
default['flink']['historyserver']['environment']     = "#{node['flink']['historyserver']['local_dir']}/historyserver.env"
default['flink']['historyserver']['xmx']             = "1g"
default['flink']['historyserver']['port']            = 29183

default['flink']['checksum']                         = ""

default['flink']['mode']                             = "BATCH"
default['flink']['jobmanager']['web_port']           = 8088
default['flink']['jobmanager']['heap_mbs']           = 256
default['flink']['taskmanager']['heap_mbs']          = 512
default['flink']['taskmanager']['managed_mbs']       = 512

default['flink']['taskmanager']['num_taskslots']     = node['cpu']['total']
default['flink']['parallelization']['degree']        = node['cpu']['total']
default['flink']['webclient_port']                   = 8888
default['flink']['taskmanager']['network_num_buffers']  = 2048

#
# Featurestore dependencies
#
default['flink']['hsfs']['version']                  = node['install']['version']
default['flink']['hsfs']['url']                      = "#{node['download_url']}/hsfs/#{node['flink']['hsfs']['version']}/hsfs-flink-#{node['flink']['hsfs']['version']}.jar"
