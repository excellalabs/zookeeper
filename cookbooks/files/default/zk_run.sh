#!/bin/bash -e

# source /etc/profile.d/proxy.sh
echo "zk_run run by $(whoami)"
echo 'ruby /usr/local/bin/eni_switcher.rb' | sudo tee --append /usr/local/bin/run_eni_switch.sh
bash /usr/local/bin/run_eni_switch.sh
# eni_name.sh is created by eni_switcher.rb
source /usr/local/bin/eni_name.sh
sleep 10
ruby /usr/local/bin/zk_server.rb
sleep 10
echo "eni_name: ${eni_name}"
# /usr/local/bin/attach_ebs.py $eni_name /dev/xvdg /var/lib/zookeeper;

service zookeeper restart
