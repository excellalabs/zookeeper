#
# Cookbook:: cookbooks
# Recipe:: default
#
# Copyright:: 2018, Ali Jafari - Excella Data Lab, All Rights Reserved.

include_recipe 'cookbooks::service'

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

package 'awscli'
package 'software-properties-common'

package 'confluent-platform-oss-2.11'

bash 'install-cfn-tools' do
  code <<-SCRIPT
  apt-get update
  apt-get -y install python-setuptools
  mkdir aws-cfn-bootstrap-latest
  curl https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz | tar xz -C aws-cfn-bootstrap-latest --strip-components 1
  easy_install aws-cfn-bootstrap-latest
  SCRIPT
end

package 'ruby'

bash 'install gems' do
  code <<-EOH
  source /usr/local/rvm/scripts/rvm
  gem install aws-sdk keystore
  EOH
end

# Prepare chef-solo work area for on-boot
directory '/var/chef/solo' do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/var/chef/solo/cookbooks-0' do
  mode '0644'
end

# Copy cookbooks off for on-boot use
script 'save cookbooks' do
  interpreter 'bash'
  code 'cp -Rp /tmp/kitchen/cache/cookbooks/cookbooks/ /var/chef/solo/cookbooks-0'
  not_if { node['test_kitchen'] }
end

# remote_directory '/var/chef/solo/cookbooks-0' do
#   source 'files/default/local_directory'
#   files_owner 'root'
#   files_group 'root'
#   files_mode '0750'
#   action :create
#   recursive true
# end


file '/var/chef/solo/solo.rb' do
  owner 'root'
  group 'root'
  mode '0400'
  content 'cookbook_path  ["/var/chef/solo/cookbooks-0"]'
end

cookbook_file '/usr/local/bin/eni_switcher.rb' do
  source 'eni_switcher.rb'
  owner 'root'
  group 'root'
  mode '0755'
end

cookbook_file '/usr/local/bin/network_config.sh.erb' do
  source 'network_config.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

cookbook_file '/usr/local/bin/zk_server.rb' do
  source 'zk_server.rb'
  owner 'root'
  group 'root'
  mode '0755'
end

cookbook_file '/usr/local/bin/zk_run.sh' do
  source 'zk_run.sh'
  owner 'root'
  group 'root'
  mode '0755'
end
