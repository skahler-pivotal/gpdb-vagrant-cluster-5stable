#!/bin/bash

echo "***** Pivotal Greenplum Database Initialization *****"

# change to the root directory
cd /

# make greenplum database commands available 
source /vagrant/build/gpdb/greenplum_path.sh

echo "***** exchange ssh keys for gpadmin between the master host, standby master host *****"
echo "***** segment host 1, segment host 2 ( mdw, sdw1 & sdw2 ) *****"
su - gpadmin -c "source /vagrant/build/gpdb/greenplum_path.sh && gpssh-exkeys -f /vagrant/sharedfiles/hostfile_exkeys"

echo "***** copy gpinitsystem_conf to /home/gpadmin/gpconfigs *****"
cp /vagrant/build/gpdb/docs/cli_help/gpconfigs/gpinitsystem_config /vagrant/sharedfiles/gpinitsystem_config
chmod 777 /vagrant/sharedfiles/gpinitsystem_config

echo "***** create hostfile with segment hosts sdw1 & sdw2 entries *****"
rm /vagrant/sharedfiles/hostfile_gpinitsystem
echo "sdw1" > /vagrant/sharedfiles/hostfile_gpinitsystem
echo "sdw2" >> /vagrant/sharedfiles/hostfile_gpinitsystem
chmod 777 /vagrant/sharedfiles/hostfile_gpinitsystem

echo "***** modify gpinitsystem_config to define /data/primary and uncomment /data/mirror parameters *****"
sed -i 's/\declare -a DATA_DIRECTORY=(\/data1\/primary \/data1\/primary \/data1\/primary \/data2\/primary \/data2\/primary \/data2\/primary)/declare -a DATA_DIRECTORY=(\/data\/primary)/g' /vagrant/sharedfiles/gpinitsystem_config
sed -i 's/#MIRROR_PORT_BASE=7000/MIRROR_PORT_BASE=7000/g' /vagrant/sharedfiles/gpinitsystem_config
sed -i 's/#REPLICATION_PORT_BASE=8000/REPLICATION_PORT_BASE=8000/g' /vagrant/sharedfiles/gpinitsystem_config
sed -i 's/#MIRROR_REPLICATION_PORT_BASE=9000/MIRROR_REPLICATION_PORT_BASE=9000/g' /vagrant/sharedfiles/gpinitsystem_config
sed -i 's/#declare -a MIRROR_DATA_DIRECTORY=(\/data1\/mirror \/data1\/mirror \/data1\/mirror \/data2\/mirror \/data2\/mirror \/data2\/mirror)/declare -a MIRROR_DATA_DIRECTORY=(\/data\/mirror)/g' /vagrant/sharedfiles/gpinitsystem_config

echo "***** create an instance of the greenplum database from gpinitsystem_config *****"
# must be run as gpadmin
# make greenplum database commands available to gpadmin
# run gpinitsystem
su - gpadmin -c "source /vagrant/build/gpdb/greenplum_path.sh && gpinitsystem -a -c /vagrant/sharedfiles/gpinitsystem_config -h /vagrant/sharedfiles/hostfile_gpinitsystem"

cd /home/gpadmin

echo "***** check the state of the greenplum database *****"
# must be run as gpadmin
# shell out gpadmin's .bash_profile
# make greenplum database commands available to gpadmin
# run gpstate
su - gpadmin -c "source /vagrant/build/gpdb/greenplum_path.sh && gpstate"
