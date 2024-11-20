// TODO: Add eval user
// TODO: Add shane ssh key

// Install LXC and dependencies
sudo apt update
sudo apt upgrade
sudo apt install lxc

sudo apt install apparmor

// verify installation and dependencies
lxc-checkconfig
