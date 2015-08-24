name             'flink'
maintainer       "Jim Dowling"
maintainer_email "jdowling@sics.se"
license          "Apache v 2.0"
description      'Installs/Configures Standalone Apache Flink'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0"

recipe           "install", "Installs Apache Flink"
#link:<a target='_blank' href='http://%host%:8088/'>Launch the WebUI for the Flink JobManager</a>
recipe           "jobmanager",  "Starts a Flink JobManager in standalone mode"
recipe           "taskmanager",   "Starts a Flink Slave in standalone mode"
recipe           "wordcount",   "Prepares wordcount example using HDFS"

depends          "hadoop"
depends          "kagent"
depends          "ark"

%w{ ubuntu debian rhel centos }.each do |os|
  supports os
end

attribute "flink/mode",
:display_name => "Run Flink JobManager in one of the following modes: batch, streaming",
:required => "required",
:type => 'string'

attribute "flink/jobmanager/heap_mbs",
:display_name => "Flink JobManager Heap Size in MB",
:required => "required",
:type => 'string'

attribute "flink/taskmanager/heap_mbs",
:display_name => "Flink TaskManager Heap Size in MB",
:required => "required",
:type => 'string'

