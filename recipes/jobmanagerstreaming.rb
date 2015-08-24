
node.default[:flink][:mode] = "streaming"

include_recipe "flink::jobmanager"
