#!/bin/bash

echo "***** Setting up Master ( mdw ) *****"
# commands that must be run from the master host ( mdw )

# change to the root directory
cd ~

echo "***** Generate key *****"
# generate ssh keys on master ( mdw )
ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa

echo "***** Copy key to authorized keys *****"
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# push ssh keys to segment host 1 ( sdw1)
/usr/bin/expect<<EOF
spawn scp -r .ssh/ sdw1:/root/.ssh
expect "Are you sure you want to continue connecting (yes/no)?"
send "yes\r"
expect "password"
send  "vagrant\r"
expect
EOF

# push ssh keys to segment host 2 ( sdw2)
/usr/bin/expect<<EOF
spawn scp -r .ssh/ sdw2:/root/.ssh
expect "Are you sure you want to continue connecting (yes/no)?"
send "yes\r"
expect "password"
send  "vagrant\r"
expect
EOF

su - gpadmin -c 'ssh-keygen -t rsa -N "" -f /home/gpadmin/.ssh/id_rsa'
su - gpadmin -c 'cat /home/gpadmin/.ssh/id_rsa.pub >> /home/gpadmin/.ssh/authorized_keys'
rsync -rtuvlog -e ssh /home/gpadmin/.ss* sdw1:/home/gpadmin/
rsync -rtuvlog -e ssh /home/gpadmin/.ss* sdw2:/home/gpadmin/
