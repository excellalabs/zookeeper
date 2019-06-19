# frozen_string_literal: true

default['confluent']['version'] = '4.1'
default['confluent']['scala_version'] = '2.11'
default['java']['jdk_version'] = '8'
override['poise-python']['options']['pip_version'] = '9.0.3'
default['rvm']['ruby_versions'] = %w[2.5.3]
default['rvm']['default_ruby'] = '2.5.3'
