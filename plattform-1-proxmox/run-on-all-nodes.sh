# Add the SSH key of our prof
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMf2NalRNgiv1bPjzF+4R4bak81D4SP7vvb0F7KeE7D sebastiangraf@laptop' | sudo tee -a ~/.ssh/authorized_keys > /dev/null

# See this link for more information about this part of the script
# https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_12_Bookworm#Install_Proxmox_VE

# Edit the /etc/hosts use the example bellow
: '
10.0.1.9        node01.novalocal        node01

# 10.0.1.9        node01
10.0.3.184      node02
10.0.1.114      node03
'
sudo vim /etc/hosts

# check if the setup is ok
# the follwoing command should return the IP address of the node
hostname --ip-address

# Add the Proxmox Repository
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" | sudo tee /etc/apt/sources.list.d/pve-install-repo.list

# Add the Proxmox VE repository key as root
sudo wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
# verify
sha512sum /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
# has to equal: 7da6fe34168adc6e479327ba517796d4702fa2f8b4f0a9833f5ea6e6b48f6507a6da403a274fe201595edc86a84463d50383d07f64bdde2e3658108db7d6dc87 /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

# Update your repository and system by running
sudo apt update && sudo apt full-upgrade

# Install the Proxmox VE Kernel
sudo apt install proxmox-default-kernel
sudo systemctl reboot

# Install the Proxmox VE packages
sudo apt install proxmox-ve postfix open-iscsi chrony

# Remove the Debian Kernel
sudo apt remove linux-image-amd64 'linux-image-6.1*'
sudo update-grub

# Recommended: Remove the os-prober Package
sudo apt remove os-prober

# Set the password to cloud1
sudo passwd

# update the /etc/network/interfaces add the bridge (make sure each host has its own ip range)
sudo vim /etc/network/interfaces
: '
source /etc/network/interfaces.d/*

iface vmbr0 inet static
        address  10.10.10.1/24
        bridge-ports none
        bridge-stp off
        bridge-fd 0

        post-up   echo 1 > /proc/sys/net/ipv4/ip_forward
        post-up   iptables -t nat -A POSTROUTING -s '10.10.10.0/24' -o ens3 -j MASQUERADE
        post-down iptables -t nat -D POSTROUTING -s '10.10.10.0/24' -o ens3 -j MASQUERADE
'

# Comment out -update_etc_hosts to prevent the configuration from being overwriten
sudo vim /etc/cloud/cloud.cfg
