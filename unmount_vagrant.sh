#!/bin/bash

# Avoid doing this since it's useful for passing files back and forth
exit 0

echo "***** Unmounting /vagrant From All Hosts *****"

# change to the root directory
cd /

# unmount the /vagrant directory
umount -l /vagrant
