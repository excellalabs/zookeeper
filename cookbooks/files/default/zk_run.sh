#!/bin/bash -e
# source /etc/profile.d/proxy.sh
# echo source /usr/local/rvm/scripts/rvm > /usr/local/bin/run_eni_switch.sh;
# echo ruby /usr/local/bin/eni_switcher.rb --environment ExDataLab >> /usr/local/bin/run_eni_switch.sh;
sudo usermod -aG sudo ubuntu
export inventory_store=Pipeline_Key_Store
export kms_id=fc112e37-27c7-4e56-b6e7-6744e226d07e
export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID=AKIAJLCDDX4CD3VGANJQ
export AWS_SECRET_ACCESS_KEY=

new_key_id=$(keystore.rb retrieve --table=$inventory_store --keyname="DEVOPS_ACCESS_KEY_ID")
new_secret_key=$(keystore.rb retrieve --table=$inventory_store --keyname="DEVOPS_SECRET_ACCESS_KEY")

export AWS_ACCESS_KEY_ID=$new_key_id
export AWS_SECRET_ACCESS_KEY=$new_secret_key

sudo echo ruby /usr/local/bin/eni_switcher.rb --environment ExDataLab > /usr/local/bin/run_eni_switch.sh;
sudo chown ubuntu:ubuntu /usr/local/bin/run_eni_switch.sh;
bash /usr/local/bin/run_eni_switch.sh;

# eni_name.sh is created by eni_switcher.rb
source /usr/local/bin/eni_name.sh;

ruby /usr/local/bin/zk_server.rb


# /usr/local/bin/attach_ebs.py $eni_name /dev/xvdg /var/lib/zookeeper;
# sudo echo ExDataLab > /etc/vdm_env;
# sudo chown ubuntu:ubuntu /etc/vdm_env;
