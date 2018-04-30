user 'zookeeper'
group 'zookeeper'

cookbook_file '/etc/systemd/system/zookeeper.service' do
  source 'systemd/zookeeper.service'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/etc/default/zookeeper' do
  source 'systemd/zookeeper_environment'
  mode '0644'
end

directory '/etc/rsyslog.d'

cookbook_file '/etc/rsyslog.d/66-zookeeper.conf' do
  source 'systemd/66-zookeeper.conf'
  mode '0644'
end

service 'zookeeper' do
  # action %i[unmask enable]
  provider Chef::Provider::Service::Systemd
end

directory '/var/lib/zookeeper' do
  recursive true
end
