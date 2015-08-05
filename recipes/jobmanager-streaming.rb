
node.default[:flink][:jobmanager][:mode] = "streaming"

include_recipe "flink::jobmanager"
