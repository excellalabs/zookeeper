# frozen_string_literal: true

require 'pipeline/deploy'

desc 'Deploy Zookeeper'
task :deploy do
  puts 'deploy cfn'
  stack_name = 'ExDataLab-ZOOKEEPER'
  Pipeline::Deploy.new(
    stack_name: stack_name,
    template: 'zookeeper_asg'
  )
end
