require 'aws-sdk'

desc 'Deploy Zookeeper'
task :deploy do
  puts 'deploy cfn'
  stack_name = 'ExDataLab-ZOOKEEPER'
  # cfn = Aws::CloudFormation::Client.new(region: 'us-east-1')
  # resp = cfn.describe_stacks(stack_name: stack_name)
  # puts resp.stacks.count
  # if resp.stacks.count.zero?
  #   create_stack(cfn, stack_name)
  # else
  #   puts 'update stack'
  # end
  Pipeline::Deploy.new(
    stack_name: stack_name,
    template: 'zookeeper_asg'
  )
end
