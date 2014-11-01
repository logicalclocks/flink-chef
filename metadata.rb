name             'flink'
maintainer       "Jim Dowling"
maintainer_email "jdowling@sics.se"
license          "Apache v 2.0"
description      'Installs/Configures Apache Flink'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0"

recipe           "install", "Installs Apache Flink"
recipe           "example", "Runs wordcoutn example"

depends          "hadoop"
depends          "hopagent"
