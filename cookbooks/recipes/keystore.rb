# frozen_string_literal: true

region = 'us-east-1'
store_name = 'Pipeline_Key_Store'
kms_id = 'fc112e37-27c7-4e56-b6e7-6744e226d07e'

# setup keystore env
vars = StringIO.new
vars << "export inventory_store=#{store_name}\n"
vars << "export kms_id=#{kms_id}\n"
vars << "export AWS_DEFAULT_REGION=#{region}\n"

file '/etc/profile.d/keystore.sh' do
  content vars.string
  owner 'root'
  group 'root'
  mode '0755'
end
