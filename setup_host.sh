#!/bin/bash

echo "***** Setting Up Host *****"

# change to the root directory
cd /

# /etc/hosts file entries on mdw, sdw1 & sdw2
echo "127.0.0.1          localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "::1                    localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
echo "172.16.1.11       mdw        # Greenplum Master Server" >> /etc/hosts
echo "172.16.1.12       sdw1       # Greenplum Segment Server 1" >> /etc/hosts
echo "172.16.1.13       sdw2       # Greenplum Segment Server 2" >> /etc/hosts

# create the /data directory on mdw, sdw1 & sdw2
mkdir data

# set vim as default editor and create alias for both root and gpadmin
echo "" >> /root/.bashrc
echo "export EDITOR=vim" >> /root/.bashrc
echo "" >> /root/.bashrc
echo "alias vi=vim" >> /root/.bashrc
echo "" >> /root/.bashrc

# create aliases on mdw, sdw1 & sdw2 to make it easier to ssh to & from any host in the cluster for root 
echo "alias mdw='ssh gpadmin@172.16.1.11'" >> /root/.bashrc
echo "alias sdw1='ssh gpadmin@172.16.1.12'" >> /root/.bashrc
echo "alias sdw2='ssh gpadmin@172.16.1.13'" >> /root/.bashrc


# Install base packages
yum -y install expect ntp ed vim nano wget nc lsof unzip rsync psutils python2-psutil
# Install dev build packages
yum -y install gcc gcc-c++ git wget ncurses-devel bzip2 bzip2-devel bison flex openssl-libs openssl-devel libcurl-devel json-c-devel readline-devel libyaml libyaml-devel libevent-devel openldap-devel libxml2-devel libxslt-devel apr-devel apr-util-devel libffi-devel libxml2-devel python-devel perl-ExtUtils-Embed zlib-devel epel-release perl-Env ccache

# Install EPEL and packages we need to retrieve
#rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
yum -y install python-pip cmake3

# Install necessary Python pieces
pip install --upgrade psutil
pip install --upgrade lockfile
pip install --upgrade paramiko
pip install --upgrade setuptools
pip install --upgrade epydoc
pip install --upgrade pyyaml

# Create the gpadmin user
useradd -m -r gpadmin -d /home/gpadmin

# Set default variables for gpadmin user
echo "" >> /home/gpadmin/.bash_profile
echo "source /vagrant/build/gpdb/greenplum_path.sh" >> /home/gpadmin/.bash_profile
echo "MASTER_DATA_DIRECTORY=/data/master/gpseg-1" >> /home/gpadmin/.bash_profile
echo "export MASTER_DATA_DIRECTORY" >> /home/gpadmin/.bash_profile
echo "" >> /home/gpadmin/.bash_profile

# create aliases on mdw, sdw1 & sdw2 to make it easier to ssh to & from any host in the cluster for gpadmin
echo "alias mdw='ssh gpadmin@172.16.1.11'" >> /home/gpadmin/.bashrc
echo "alias sdw1='ssh gpadmin@172.16.1.12'" >> /home/gpadmin/.bashrc
echo "alias sdw2='ssh gpadmin@172.16.1.13'" >> /home/gpadmin/.bashrc

# turn off selinux
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*$/SELINUX=disabled/' /etc/selinux/config

# GPDB Kernel Settings
sudo rm -f /etc/sysctl.d/gpdb.conf
sudo bash -c 'printf "# GPDB-Specific Settings\n\n"                    >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "kernel.shmmax = 500000000\n"                     >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "kernel.shmmni = 4096\n"                          >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "kernel.shmall = 4000000000\n"                    >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "kernel.sem = 500 1024000 200 4096\n"             >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "kernel.sysrq = 1\n"                              >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "kernel.core_uses_pid = 1\n"                      >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "kernel.msgmnb = 65536\n"                         >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "kernel.msgmax = 65536\n"                         >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "kernel.msgmni = 2048\n"                          >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "net.ipv4.tcp_syncookies = 1\n"                   >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "net.ipv4.ip_forward = 1\n"                       >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "net.ipv4.conf.default.accept_source_route = 0\n" >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "net.ipv4.tcp_tw_recycle = 1\n"                   >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "net.ipv4.tcp_max_syn_backlog = 4096\n"           >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "net.ipv4.conf.all.arp_filter = 1\n"              >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "net.ipv4.ip_local_port_range = 1025 65535\n"     >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "net.ipv6.conf.all.disable_ipv6 = 1\n             >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "net.core.netdev_max_backlog = 10000\n"           >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "net.core.rmem_max = 2097152\n"                   >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "net.core.wmem_max = 2097152\n"                   >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "vm.overcommit_memory = 2\n"                      >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "kernel.core_uses_pid = 1\n"                      >> /etc/sysctl.d/gpdb.conf'
sudo bash -c 'printf "kernel.core_pattern = /tmp/gpdb_cores/core-%%e-%%s-%%u-%%g-%%p-%%t\n" >> /etc/sysctl.d/gpdb.conf'
sudo sysctl -p /etc/sysctl.d/gpdb.conf

# Update limits to those needed for GPDB
sudo rm -f /etc/security/limits.d/gpdb.conf
sudo bash -c 'printf "# GPDB-Specific Settings\n\n"     >> /etc/security/limits.d/gpdb.conf'
sudo bash -c 'printf "* soft nofile 65536\n"            >> /etc/security/limits.d/gpdb.conf'
sudo bash -c 'printf "* hard nofile 65536\n"            >> /etc/security/limits.d/gpdb.conf'
sudo bash -c 'printf "* soft nproc 131072\n"            >> /etc/security/limits.d/gpdb.conf'
sudo bash -c 'printf "* hard nproc 131072\n"            >> /etc/security/limits.d/gpdb.conf'
sudo bash -c 'printf "* soft core unlimited\n"         >> /etc/security/limits.d/gpdb.conf'
sudo bash -c 'printf "* hard core unlimited\n"         >> /etc/security/limits.d/gpdb.conf'
