require 'vagrant-omnibus'

Vagrant.configure("2") do |c|

  if Vagrant.has_plugin?("vagrant-cachier")
    c.cache.auto_detect = false
    c.cache.enable :apt
  end
  c.omnibus.cache_packages = false

  c.omnibus.chef_version = "12.4.3"
  c.vm.box = "opscode-ubuntu-14.04"
  c.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/20150924.0.0/providers/virtualbox.box"

  #c.vm.hostname = "default-ubuntu-1404.vagrantup.com"

  c.vm.provider :virtualbox do |p|
    p.customize ["modifyvm", :id, "--memory", "3000"]
    p.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    p.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    p.customize ["modifyvm", :id, "--nictype1", "virtio"]
  end

  c.vm.define :master do |master|

# HTTP webserver
  master.vm.network(:forwarded_port, {:guest=>8080, :host=>8080})
# HDFS webserver
  master.vm.network(:forwarded_port, {:guest=>50070, :host=>50070})
# Flink webserver
  master.vm.network(:forwarded_port, {:guest=>9088, :host=>9088})

   master.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = "cookbooks"
     chef.json = {
     "vagrant" => "true",
     "zookeeper" => {
	  "default" =>      { 
   	  	       "private_ips" => ["10.0.2.15"]
	       },
     },
     "flink" => {
	  "jobmanager" =>      { 
   	  	       "private_ips" => ["10.0.2.15"]
	       },
	  "taskmanager" =>      { 
   	  	       "private_ips" => ["10.0.2.15"]
	       },
     },
     "public_ips" => ["10.0.2.15"],
     "private_ips" => ["10.0.2.15"],
     "hadoop"  =>    {
		 "nn" =>    { 
       	  	      "private_ips" => ["10.0.2.15"]
                 },
		 "dn" =>    { 
       	  	      "private_ips" => ["10.0.2.15"]
                 },

      },
     "kkafka" => {
	  "default" =>    { 
       	 	      "private_ips" => ["10.0.2.15"]
       }
     },
     }

      chef.add_recipe "kagent::install"
      chef.add_recipe "ndb::install"
      chef.add_recipe "hadoop::install"
      chef.add_recipe "spark::install"
      chef.add_recipe "flink::install"
      chef.add_recipe "kzookeeper::install"
      chef.add_recipe "kkafka::install"
      chef.add_recipe "hadoop::nn"
      chef.add_recipe "hadoop::nm"
      chef.add_recipe "spark::master"
      chef.add_recipe "flink::jobmanager"
  end 

    master.vm.network :private_network, ip: "10.211.55.100"
    master.vm.hostname = "vm-cluster-node1"

  end

  config.vm.define :slave1 do |slave1|


   slave1.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = "cookbooks"
     chef.json = {
     "vagrant" => "true",
     "zookeeper" => {
	  "default" =>      { 
   	  	       "private_ips" => ["10.0.2.15"]
	       },
     },
     "flink" => {
	  "jobmanager" =>      { 
   	  	       "private_ips" => ["10.0.2.15"]
	       },
	  "taskmanager" =>      { 
   	  	       "private_ips" => ["10.0.2.15"]
	       },
     },
     "public_ips" => ["10.0.2.15"],
     "private_ips" => ["10.0.2.15"],
     "hadoop"  =>    {
     	        "yarn" => {
		      "user" => "glassfish"
		 },
		 "mr" => {
		      "user" => "glassfish"
		 },
		 "rm" =>    { 
       	  	      "private_ips" => ["10.0.2.15"]
                 },
		 "nn" =>    { 
       	  	      "private_ips" => ["10.0.2.15"]
                 },
		 "dn" =>    { 
       	  	      "private_ips" => ["10.0.2.15"]
                 },
		 "nm" =>    { 
       	  	      "private_ips" => ["10.0.2.15"]
                 },
		 "jhs" =>    { 
       	  	      "private_ips" => ["10.0.2.15"]
                 },
      },
     "kkafka" => {
	  "default" =>    { 
       	 	      "private_ips" => ["10.0.2.15"]
       }
     },
     "zeppelin" => {
	  "user" => "glassfish",
	  "default" =>    { 
       	 	      "private_ips" => ["10.0.2.15"]
          }
     },

     }

      chef.add_recipe "kagent::install"
      chef.add_recipe "hops::install"
      chef.add_recipe "spark::install"
      chef.add_recipe "flink::install"
      chef.add_recipe "kzookeeper::install"      
      chef.add_recipe "hops::ndb"
      chef.add_recipe "hops::dn"
      chef.add_recipe "spark::worker"
      chef.add_recipe "flink::taskmanager"
  end 
    
    slave1.vm.network :private_network, ip: "10.211.55.101"
    slave1.vm.hostname = "vm-cluster-node2"
  end

  config.vm.define :client do |client|

    client.vm.network :private_network, ip: "10.211.55.105"
    client.vm.hostname = "vm-cluster-client"
  end

end
