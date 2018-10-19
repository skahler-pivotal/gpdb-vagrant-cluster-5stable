#!/bin/bash

echo "This is $0"

# Install base packages
yum -y install gcc gcc-c++ git wget ncurses-devel bzip2 bison flex openssl-devel libcurl-devel json-c-devel readline-devel bzip2-devel libyaml libyaml-devel libevent-devel openldap-devel libxml2-devel libxslt-devel apr-devel apr-util-devel libffi-devel libxml2-devel python-devel perl-ExtUtils-Embed

# Install EPEL and packages we need to retrieve
rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
yum -y install python-pip cmake3

# Install necessary Python pieces
pip install --upgrade psutil
pip install --upgrade lockfile
pip install --upgrade paramiko
pip install --upgrade setuptools
pip install --upgrade epydoc
pip install --upgrade pyyaml
