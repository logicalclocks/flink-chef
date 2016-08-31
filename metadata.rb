name             "flink"
maintainer       "Jim Dowling"
maintainer_email "jdowling@sics.se"
license          "Apache v 2.0"
description      'Installs/Configures Standalone Apache Flink'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.3"
source_url       'https://github.com/hopshadoop/flink-chef'

recipe           "install", "Installs Apache Flink"
#link:<a target='_blank' href='http://%host%:8088/'>Launch the WebUI for the Flink JobManager</a>
recipe           "jobmanager",  "Starts a Flink JobManager in standalone mode"
recipe           "yarn",  "Sets up flink for running on YARN"
recipe           "taskmanager",   "Starts a Flink Slave in standalone mode"
recipe           "wordcount",   "Prepares wordcount example using HDFS"
recipe           "purge",   "Remove and delete Flink"

depends          "apache_hadoop"
depends          "hops"
depends          "kagent"
depends          "java"

%w{ ubuntu debian rhel centos }.each do |os|
  supports os
end


attribute "java/jdk_version",
          :description =>  "Jdk version",
          :type => 'string'

attribute "java/install_flavor",
          :description =>  "Oracle (default) or openjdk",
          :type => 'string'

attribute "flink/user",
          :description => "Username to run flink jobmgr/task as",
          :type => 'string'

attribute "flink/group",
          :description => "Groupname to run flink jobmgr/task as",
          :type => 'string'

attribute "flink/mode",
          :description => "Run Flink JobManager in one of the following modes: BATCH, STREAMING",
          :type => 'string'

attribute "flink/jobmanager/heap_mbs",
          :description => "Flink JobManager Heap Size in MB",
          :type => 'string'

attribute "flink/taskmanager/heap_mbs",
          :description => "Flink TaskManager Heap Size in MB",
          :type => 'string'

attribute "flink/dir",
          :description => "Root directory for flink installation",
          :type => 'string'

attribute "flink/taskmanager/num_taskslots",
          :description => "Override the default number of task slots (default = NoOfCPUs)",
          :type => 'string'

attribute "flink/hadoop/distribution",
          :description => "apache_hadoop (default) or hops",
          :type => 'string'
