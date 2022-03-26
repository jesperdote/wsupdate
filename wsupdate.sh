#!/bin/bash

if [ ! -n "$1" ] ; then
	echo 'Missing argument: new_hostname'
	exit 1
fi

if [ ! -n "$2" ] ; then
        echo 'Missing argument: ip_addei'
        exit 1
fi

if [ "$(id -u)" != "0" ] ; then
	echo "Sorry, you are not root."
	exit 2
fi

CUR_HOSTNAME=$(cat /etc/hostname)
NEW_HOSTNAME=$1
NEW_IP=$2

# Display the current hostname
echo "The current hostname is $CUR_HOSTNAME"

# Change the hostname
hostnamectl set-hostname $NEW_HOSTNAME
hostname $NEW_HOSTNAME

# Change hostname in /etc/hosts & /etc/hostname
sudo sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
sudo sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hostname

# Display new hostname
echo "The new hostname is $NEW_HOSTNAME"


# Display updating rssh config
echo "Changing the IP address for reverse ssh to $NEW_IP"

sed -i "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$NEW_IP/g" /etc/systemd/system/ssh-reverse-ssh.service
#sudo systemctl daemon-reload

# Display restarting in 5 seconds
echo "Restarting in 2 seconds..."
sleep 2s
sudo reboot 
###





