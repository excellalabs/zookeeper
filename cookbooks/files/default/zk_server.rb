require 'erb'
require 'aws-sdk'
require 'trollop'
require 'net/http'

class ZKServer
  attr_accessor :zk_ip_1, :zk_ip_2, :zk_ip_3
  def setup_myid(instance_az)
    # template = ERB.new File.read('myid.erb')
    zk_id = case instance_az
      when 'us-east-1a' then '1'
      when 'us-east-1b' then '2'
      else '3'
    end
    File.write('/var/lib/zookeeper/myid', zk_id)
    zk_id
  end

  def initialize(region)
    @zk_ip_1 = '10.100.1.100'
    @zk_ip_2 = '10.100.2.100'
    @zk_ip_3 = '10.100.3.100'
  end

  def setup_zk_config(instance_az)
    zk_ip = case instance_az
      when 'us-east-1a' then zk_ip_1
      when 'us-east-1b' then zk_ip_2
      else zk_ip_3
    end
    conf = StringIO.new
    conf << "tickTime=2000\n"
    conf << "dataDir=/var/lib/zookeeper/\n"
    conf << "clientPort=2181\n"
    conf << "initLimit=5\n"
    conf << "syncLimit=2\n"
    conf << "autopurge.snapRetainCount=3\n"
    conf << "autopurge.purgeInterval=24\n"
    conf << "server.1=#{zk_ip == zk_ip_1 ? '0.0.0.0' : zk_ip_1}:2888:3888\n"
    conf << "server.2=#{zk_ip == zk_ip_2 ? '0.0.0.0' : zk_ip_2}:2888:3888\n"
    conf << "server.3=#{zk_ip == zk_ip_3 ? '0.0.0.0' : zk_ip_3}:2888:3888\n"

    File.write('/etc/kafka/zookeeper.properties', conf.string)
  end

  def update_zk_tag(region, instance_id, zk_id)
    client=Aws::EC2::Client.new(region: region)
    resp = client.delete_tags({resources: [instance_id]})
    resp = client.create_tags({
      resources: [
        instance_id, 
      ], 
      tags: [
        {
          key: 'Name', 
          value: "ZOOKEEPER-#{zk_id}", 
        }, 
      ], 
    })
  end
end

opts = Trollop.options do
  opt :region, 'The AWS Region the instance and ENI live in', type: String, default: 'us-east-1'
end

metadata_endpoint = 'http://169.254.169.254/latest/meta-data/'
instance_id = Net::HTTP.get(URI.parse(metadata_endpoint + 'instance-id'))
puts 'instance_id=' + instance_id
instance_az = Net::HTTP.get(URI.parse(metadata_endpoint + 'placement/availability-zone'))
zk = ZKServer.new(opts[:region])
puts zk.zk_ip_1
puts zk.zk_ip_2
puts zk.zk_ip_3
zk_id = zk.setup_myid(instance_az)
zk.setup_zk_config(instance_az)
ZKServer.update_zk_tag(opts[:region], instance_id, zk_id)
