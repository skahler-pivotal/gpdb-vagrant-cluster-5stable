#!/bin/bash

echo "***** Building GPDB ( mdw ) *****"

# place for gpdb bits
mkdir -p /vagrant/build/gpdb

# place for gpdb source
mkdir -p /vagrant/source

# build GPDB in the vagrant directory
cd /vagrant/source
rm -rf gpdb
git clone https://github.com/greenplum-db/gpdb.git
cd gpdb
git checkout 5X_STABLE

./configure --with-perl --with-python --with-libxml --disable-orca --disable-mapreduce --prefix=/vagrant/build/gpdb CFLAGS="-I/vagrant/build/gpdb/include/ -L/vagrant/build/gpdb/lib/"
make -j8
make install
