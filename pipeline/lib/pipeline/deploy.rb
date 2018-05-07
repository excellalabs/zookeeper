# frozen_string_literal: true

require 'aws-sdk'
require 'eat'
require 'pipeline/state'
require 'pipeline/cfn_helper'

# rubocop:disable Metrics/MethodLength
# Pipeline
module Pipeline
  # Deployment class for all environments
  class Deploy < CloudFormationHelper
    def initialize(params = {})
      @params = params
      @cloudformation = Aws::CloudFormation::Client
                        .new(region: aws_region)

      deploy
    end

    def deploy
      return create_stack unless stack_exists?
      update_stack
    end

    def create_stack
      @cloudformation.create_stack(cfn_parameters(@params[:template]))
      wait_and_save(:stack_create_complete)
    end

    def update_stack
      @cloudformation.update_stack(cfn_parameters(@params[:template]))
      wait_and_save(:stack_update_complete)
    end

    def stack_parameters
      [
        parameter('VpcId', 'vpc-bfade9c4'),
        parameter('AmiId', 'ami-064bcd79'),
        parameter('AsgSubnets',
                  'subnet-5a7dd010,subnet-f9ecf5a4,subnet-d88a7ebf'),
        parameter('AsgSubnetAzs', 'us-east-1a,us-east-1b,us-east-1c'),
        parameter('KeyName', 'devops-ex'),
        parameter('InstanceCount', 3),
        parameter('MinInstancesInService', 1),
        parameter('Subnet1', 'subnet-5a7dd010'),
        parameter('Subnet2', 'subnet-f9ecf5a4'),
        parameter('Subnet3', 'subnet-d88a7ebf'),
        parameter('PipelineInstanceId', 'unspecified'),
        parameter('InstanceSecgroup', 'sg-77fa673e')
      ]
    end

    def wait_and_save(waiter_name)
      waiter(waiter_name)
      # save_stack_info
    end

    def save_stack_info
      Pipeline::State.store(namespace: @params[:environment],
                            key: 'STACK_NAME',
                            value: stack_name)
      Pipeline::State.store(namespace: @params[:environment],
                            key: 'WEBSERVER_IP',
                            value: public_ip)
      Pipeline::State.store(namespace: @params[:environment],
                            key: 'WEBSERVER_PRIVATE_IP',
                            value: private_ip)
      Pipeline::State.store(namespace: @params[:environment],
                            key: 'KEYPAIR_NAME',
                            value: stack_name)
      Pipeline::State.store(namespace: @params[:environment],
                            key: 'KEYPAIR_PATH',
                            value: "#{stack_name}.pem")
    end

    def public_ip
      stack = @cloudformation.describe_stacks(stack_name: stack_name)
                             .stacks.first

      stack.outputs.each do |output|
        return output.output_value if output.output_key == 'EC2PublicIP'
      end
    end

    def private_ip
      stack = @cloudformation.describe_stacks(stack_name: stack_name)
                             .stacks.first

      stack.outputs.each do |output|
        return output.output_value if output.output_key == 'EC2PrivateIP'
      end
    end

    def stack_name
      # "EXDATALAB-ZOOKEEPER-#{@params[:environment].upcase}"
      @params[:stack_name]
    end
  end
end
# rubocop:enable Metrics/MethodLength
