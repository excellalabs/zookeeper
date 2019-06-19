# frozen_string_literal: true

# Cookbook name:: zookeeper-config
# Recipe:: rvm

# rubocop:disable Naming/HeredocDelimiterNaming
bash 'installing rvm' do
  code <<-EOH
    sudo apt install -y software-properties-common
    sudo apt-add-repository -y ppa:rael-gc/rvm
    sudo apt update
    sudo apt install -y rvm
    source /etc/profile.d/rvm.sh
  EOH
end

group 'rvm' do
  members ['ubuntu', 'root', 'zookeeper']
  append true
end

ruby_versions = node['rvm']['ruby_versions']

user_environment = {
  'HOME' => '/var/lib/zookeeper',
  'USER' => 'zookeeper'
}

ruby_versions.each do |ruby_version|
  bash "install #{ruby_version} with read-only autolibs" do
    user 'zookeeper'
    group 'rvm'
    environment user_environment
    code <<-RUBYINSTALLCMD
      bash -l -c 'rvm autolibs read-only; rvm install ruby-#{ruby_version}; gem install bundler'
    RUBYINSTALLCMD
  end
end

default_ruby = node['rvm']['default_ruby']

bash 'set default ruby version' do
  user 'zookeeper'
  group 'rvm'
  environment user_environment
  code <<-EOH
    bash -l -c 'rvm autolibs read-only; source /etc/profile.d/rvm.sh; rvm --default use #{default_ruby}'
  EOH
end
# rubocop:enable Naming/HeredocDelimiterNaming
