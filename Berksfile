source "https://api.berkshelf.com"

metadata

cookbook 'java'
cookbook 'kagent', github: 'karamelchef/kagent-chef'
cookbook 'hadoop', github: 'hopshadoop/apache-hadoop-chef'
cookbook 'hops', github: 'hopshadoop/hops-hadoop-chef', branch: 'master'
cookbook 'ndb', github: 'hopshadoop/ndb-chef', branch: 'master'
cookbook 'ark'
cookbook 'ulimit'

group :test do
  cookbook 'apt'
end

