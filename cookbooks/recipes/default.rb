#
# Cookbook:: cookbooks
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# include_recipe 'zookeeper::default'
# include_recipe 'zookeeper::service'

# include_recipe 'cookbooks::service'

script 'download confluent key' do
  interpreter 'bash'
  code 'wget -qO - http://packages.confluent.io/deb/4.1/archive.key ' \
       '| apt-key add -'
end

script 'add confluent apt repo' do
  interpreter 'bash'
  code 'add-apt-repository "deb [arch=amd64] ' \
       'http://packages.confluent.io/deb/4.1 stable main"'
end

script 'apt-get update' do
  interpreter 'bash'
  code 'apt-get update'
end

# package 'awscli'
package 'software-properties-common'

# package 'confluent-platform-oss-2.11'
include_recipe 'confluent-cookbook::default'
include_recipe 'confluent-cookbook::zookeeper'

service 'zookeeper' do
  action %i[unmask enable]
  provider Chef::Provider::Service::Systemd
end
