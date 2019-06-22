# frozen_string_literal: true

require 'aws-sdk'
require 'pipeline/deploy'
require 'pipeline/keystore'

# rubocop:disable Metrics/BlockLength

desc 'Deploy Zookeeper'
task :deploy do
  puts 'deploy cfn'
  stack_name = 'XSP-ZOOKEEPER'
  ks = Pipeline::Keystore.new
  subnet1 = ks.query?('PRIVATE_SUBNET_1')
  subnet2 = ks.query?('PRIVATE_SUBNET_2')
  subnet3 = ks.query?('PRIVATE_SUBNET_3')
  asg_subnets = [subnet1, subnet2, subnet3].join(',')
  azs = []
  [subnet1, subnet2, subnet3].each do |subnet|
    azs << get_availability_zone(subnet)
  end
  asg_subnet_azs = azs.join(',')

  cfn_params = [
    'VpcId' => ks.query?('VPC_ID'),
    'AmiId' => ks.query?('ZOOKEEPER_LATEST_AMI'),
    'AsgSubnets' => asg_subnets,
    'AsgSubnetAzs' => asg_subnet_azs,
    'KeyName' => ks.query?('SSH_KEYNAME'),
    'InstanceCount' => '3',
    'MinInstancesInService' => '1',
    'Subnet1' => subnet1,
    'Subnet2' => subnet2,
    'Subnet3' => subnet3,
    'PipelineInstanceId' => 'unspecified',
    'InstanceSecgroup' => ks.query?('PRIVATE_SECURITY_GROUP'),
    'InstanceType' => 't2.small'
  ]

  Pipeline::Deploy.new(
    stack_name: stack_name,
    template: 'zookeeper_asg',
    cfn_params: cfn_params
  )
end

def get_availability_zone(subnet_id)
  ec2 = Aws::EC2::Client.new
  subnet = ec2.describe_subnets(
    filters: [
      {
        name: 'subnet-id',
        values: [subnet_id]
      }
    ]
  ).subnets.first
  subnet.availability_zone
end

# rubocop:enable Metrics/BlockLength
