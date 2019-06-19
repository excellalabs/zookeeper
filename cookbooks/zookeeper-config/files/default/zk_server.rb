# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/LineLength, Lint/UnusedMethodArgument
require 'erb'
require 'aws-sdk'
require 'trollop'
require 'net/http'

# Setup zk server
class ZKServer
  attr_accessor :zk_ip1, :zk_ip2, :zk_ip3
  def setup_myid(instance_az)
    @instance_ip = get_instance_ip(instance_az)
    template = ERB.new File.read('/usr/local/bin/myid.erb')
    zk_id = template.result(binding)
    File.write('/var/lib/zookeeper/myid', zk_id)
    zk_id.strip
  end

  def initialize(region)
    @zk_ip1 = '172.31.1.100'
    @zk_ip2 = '172.31.2.100'
    @zk_ip3 = '172.31.3.100'
  end

  def get_instance_ip(instance_az)
    case instance_az
    when 'us-east-1a' then zk_ip1
    when 'us-east-1b' then zk_ip2
    else zk_ip3
    end
  end

  def setup_zk_config(instance_az)
    @instance_ip = get_instance_ip(instance_az)
    template = ERB.new File.read('/usr/local/bin/zookeeper.properties.erb')
    conf = template.result(binding)
    puts conf
    File.write('/etc/kafka/zookeeper.properties', conf)
  end

  def update_zk_tag(region, instance_id, zk_id)
    client = Aws::EC2::Client.new(region: region)
    client.delete_tags(resources: [instance_id])
    client.create_tags(
      resources: [
        instance_id
      ],
      tags: [
        {
          key: 'Name',
          value: "ZOOKEEPER-#{zk_id}"
        }
      ]
    )
  end
end

opts = Trollop.options do
  opt :region, 'The AWS Region the instance and ENI live in', type: String, default: 'us-east-1'
end

metadata_endpoint = 'http://169.254.169.254/latest/meta-data/'
instance_id = Net::HTTP.get(URI.parse(metadata_endpoint + 'instance-id'))
puts "Instance Id=#{instance_id}"
instance_az = Net::HTTP.get(URI.parse(metadata_endpoint + 'placement/availability-zone'))
zk = ZKServer.new(opts[:region])
zk_id = zk.setup_myid(instance_az)
puts "Zookepeper Id: #{zk_id}"
puts "Instance Zone: #{instance_az}"
zk.setup_zk_config(instance_az)
zk.update_zk_tag(opts[:region], instance_id, zk_id)
puts '*** DONE SETTING ZOOKEEPER SERVER ***'

# rubocop:enable Metrics/MethodLength, Metrics/LineLength, Lint/UnusedMethodArgument
