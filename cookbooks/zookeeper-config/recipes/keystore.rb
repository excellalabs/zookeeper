# frozen_string_literal: true

region = 'us-east-1'
store_name = 'xsp-secret-store-KeystoreTable-J70V019TOWVB'
kms_id = '2ef14fee-bc34-4ada-9063-ffdb931f236f'

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
