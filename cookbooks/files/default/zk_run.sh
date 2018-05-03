#!/bin/bash -e

# source /etc/profile.d/proxy.sh
# echo source /usr/local/rvm/scripts/rvm > /usr/local/bin/run_eni_switch.sh;
# echo ruby /usr/local/bin/eni_switcher.rb --environment ExDataLab >> /usr/local/bin/run_eni_switch.sh;
sudo usermod -aG sudo ubuntu
echo 'ruby /usr/local/bin/eni_switcher.rb' | sudo tee --append /usr/local/bin/run_eni_switch.sh;
sudo chown ubuntu:ubuntu /usr/local/bin/run_eni_switch.sh;
sudo bash /usr/local/bin/run_eni_switch.sh;
# eni_name.sh is created by eni_switcher.rb
source /usr/local/bin/eni_name.sh;
sleep 10;
sudo ruby /usr/local/bin/zk_server.rb;
sleep 10;
sudo service zookeeper restart

# /usr/local/bin/attach_ebs.py $eni_name /dev/xvdg /var/lib/zookeeper;
# sudo echo ExDataLab > /etc/vdm_env;
# sudo chown ubuntu:ubuntu /etc/vdm_env;
