name             "flink"
maintainer       "Theofilos Kakantousis"
maintainer_email "theo@logicalclocks.com"
license          "Apache v 2.0"
description      'Installs/Configures Standalone Apache Flink'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.4.0"
source_url       'https://github.com/hopshadoop/flink-chef'

recipe           "install", "Installs Apache Flink"
recipe           "default", "Default recipe runs on all machines, needed to invoke install."
recipe           "yarn",    "Sets up flink for running on YARN"
recipe           "historyserver", "Sets up flink history server"
recipe           "purge",   "Remove and delete Flink"

depends 'conda'
depends 'kagent'
depends 'hops'
depends 'ndb'
depends 'java'

%w{ ubuntu debian rhel centos }.each do |os|
  supports os
end

attribute "flink/user",
          :description => "Username to run flink jobmgr/task as",
          :type => 'string'

attribute "flink/user_id",
          :description => "flink used id. Default: 1510",
          :type => 'string'

attribute "flink/user-home",
          :description => "Home directory of flink user",
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

attribute "install/dir",
          :description => "Set to a base directory under which we will install.",
          :type => "string"

attribute "flink/url",
          :description => "Set to the url from which to download flink.",
          :type => "string"

attribute "install/user",
          :description => "User to install the services as",
          :type => "string"

#History server
attribute "flink/historyserver/local_dir",
          :description => "Dir to store the completed jobs files on local machine",
          :type => 'string'

attribute "flink/historyserver/remote_dir",
          :description => "Dir to store the completed jobs files on remote filesystem",
          :type => 'string'

attribute "flink/historyserver/logs",
          :description => "Log dir for flink history server",
          :type => 'string'

attribute "flink/historyserver/tmp",
          :description => "Dir to store temp files of flink history server",
          :type => 'string'

attribute "flink/historyserver/port",
          :description => "Port of flink history server web UI",
          :type => 'string'

#Beam
attribute "beamjobserver_jar/url",
          :description => "Download beam flink job server url",
          :type => "string"
