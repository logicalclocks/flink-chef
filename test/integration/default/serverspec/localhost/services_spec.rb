
require 'spec_helper'

describe service('namenode') do  
  it { should be_enabled   }
  it { should be_running   }
end 

describe service('datanode') do  
  it { should be_enabled   }
  it { should be_running   }
end 

describe service('jobmanager') do  
  it { should be_running   }
end 

describe service('taskmanager') do  
  it { should be_running   }
end 

describe command("su hdfs -l -c \"/srv/hadoop/bin/hdfs dfs -ls /User\"") do
  its (:stdout) { should match /flink/ }
end

#describe command("su spark -l -c \"/srv/spark/bin/run-example SparkPi 10\"") do
#  its (:stdout) { should match /Pi is roughly/ }
#end


