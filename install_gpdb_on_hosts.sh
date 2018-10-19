#!/bin/bash

# change to the root directory
mkdir -p /vagrant/sharedfiles/

cd /vagrant/sharedfiles/

# make greenplum database commands available
source /vagrant/build/gpdb/greenplum_path.sh

# create hostfile_exkeys containing all host names
rm -f /vagrant/sharedfiles/hostfile_exkeys
echo "mdw" > /vagrant/sharedfiles/hostfile_exkeys
echo "sdw1" >> /vagrant/sharedfiles/hostfile_exkeys
echo "sdw2" >> /vagrant/sharedfiles/hostfile_exkeys

chmod 777 /vagrant/sharedfiles/hostfile_exkeys

echo "***** exchange ssh keys for root between the master host, standby master host *****"
echo "***** segment host 1, segment host 2 ( mdw, sdw1 & sdw2 ) *****"
gpssh-exkeys -f /vagrant/sharedfiles/hostfile_exkeys

# create hostfile_gpssh_segonly containing only segment host names

rm -f /vagrant/sharedfiles/hostfile_gpssh_segonly
echo "sdw1" > /vagrant/sharedfiles/hostfile_gpssh_segonly
echo "sdw2" >> /vagrant/sharedfiles/hostfile_gpssh_segonly
chmod 777 /vagrant/sharedfiles/hostfile_gpssh_segonly

# test that all hosts are accessable and have their own copy of the greenplum software installed
gpssh -f /vagrant/sharedfiles/hostfile_exkeys -e ls -la $GPHOME

echo "***** Creating The Data Storage Area's *****"

cd /

echo "***** Creating /data/master directories on master host ( mdw ) *****"

mkdir data/master

chown gpadmin:gpadmin /data/master

echo "***** Creating /data/master directories on segment hosts ( sdw1 & sdw2 )*****"
gpssh -f /vagrant/sharedfiles/hostfile_gpssh_segonly -e 'mkdir /data/primary /data/mirror; chown -R gpadmin:gpadmin /data/'

#check /data directories on all hosts
gpssh -h mdw -e 'ls -laR /data'
gpssh -h sdw1 -e 'ls -laR /data'
gpssh -h sdw2 -e 'ls -laR /data'
