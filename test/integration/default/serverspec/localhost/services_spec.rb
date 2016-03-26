
require 'spec_helper'

describe service('namenode') do  
  it { should be_enabled   }
  it { should be_running   }
end 

describe service('datanode') do  
  it { should be_enabled   }
  it { should be_running   }
end 

# describe service('jobmanager') do  
#   it { should be_running   }
# end 

# describe service('taskmanager') do  
#   it { should be_running   }
# end 

describe command("su hdfs -l -c \"/srv/hadoop/bin/hdfs dfs -ls /user\"") do
  its (:stdout) { should match /flink/ }
end

describe command("grep -Fxvf /home/spark/.ssh/id_rsa.pub /home/spark/.ssh/authorized_keys") do
  its (:stdout) { should match // }
end
