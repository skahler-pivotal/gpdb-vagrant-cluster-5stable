#!/bin/bash

echo "***** Performing System Verification Tests On All Hosts *****"

# change to the root directory
cd /

# make greenplum database commands available
source /vagrant/build/gpdb/greenplum_path.sh

echo "***** save, stop and disable iptables *****"
gpssh -f /vagrant/sharedfiles/hostfile_exkeys -e 'systemctl stop firewalld.service'
gpssh -f /vagrant/sharedfiles/hostfile_exkeys -e 'systemctl disable firewalld.service'

