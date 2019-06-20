#!/bin/bash --login

# source /etc/profile.d/proxy.sh
echo "zk_run run by $(whoami)"
# echo 'ruby /usr/local/bin/eni_switcher.rb' | sudo tee --append /usr/local/bin/run_eni_switch.sh
# bash /usr/local/bin/run_eni_switch.sh
ruby --version
rvm use 2.5.3
ruby /usr/local/bin/eni_switcher.rb
sleep 20
# eni_name.sh is created by eni_switcher.rb
source /usr/local/bin/eni_name.sh
echo "eni_name: ${eni_name}"
/usr/local/bin/attach_ebs.py $eni_name /dev/xvdg /var/lib/zookeeper;
sleep 20
ruby /usr/local/bin/zk_server.rb
sleep 10
service zookeeper restart
