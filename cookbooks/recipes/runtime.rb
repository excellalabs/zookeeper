# frozen_string_literal: true

# include_recipe 'cookbooks::service'

# eth1_addresses = node.network.interfaces.eth1.addresses
# inet_addresses = eth1_addresses.map do |address, properties|
#   address if properties['family'] == 'inet'
# end
# eni_ip = inet_addresses.reject(&:nil?).first

# Chef::Log.info "ENI IP: #{eni_ip}"

# template '/etc/kafka/zookeeper.properties' do
#   source 'zookeeper.properties.erb'
#   owner 'root'
#   group 'root'
#   mode '0644'
#   variables(instance_ip: eni_ip)
#   notifies :restart, 'service[zookeeper]', :delayed
# end

# template '/var/lib/zookeeper/myid' do
#   source 'myid.erb'
#   owner 'root'
#   group 'root'
#   mode '0644'
#   variables(instance_ip: eni_ip)
#   notifies :restart, 'service[zookeeper]', :delayed
# end
