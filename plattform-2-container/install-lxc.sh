# Add the SSH key of our prof
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMf2NalRNgiv1bPjzF+4R4bak81D4SP7vvb0F7KeE7D sebastiangraf@laptop' | sudo tee -a ~/.ssh/authorized_keys > /dev/null

# Add eval user
# password 1234
sudo adduser eval

# Allow passwordless sudo privleges (add following to sudoers file)
sudo visudo
: '
eval ALL=(ALL) NOPASSWD: ALL
'

# create and Add ssh key to evalUser authorized_keys file
mkdir -p ~/.ssh

chmod 700 ~/.ssh

touch ~/.ssh/authorized_keys

chmod 600 ~/.ssh/authorized_keys

# Add Shanes ssh key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtMSm3Vi0ReI7Bv6vJCv6d4XjCobQ2MebIWk1rmKrP1aZInVoU+Z5NUVKn/Ze4Gqs0wjvbVBTVBaGBG+1z/DJRDmyqHqJ29lSvGfQqsXenTs5LqnXYHaNFUbqrxcWBGmYOcRjbWx+1tIFOs/LRFfM+74HJcCcVde6L6T3DLB6HsWrtnTDDXDoTJbxNVzjDcmft6bxvm3mS3L8ZHpmcgKVQLdlQLTfCXsXJzZyRQ37Bc1hc1c/t7KEphGgzpAr0BM+t/Rffcqq57gyrIfLseb1PIPTwJ1qjePcAhchvVV4YsbtFJJb9JMX6rqi+t9NnlXuCwXF8ulZaTaJ7UkijQqjw78m7jLz2eQaMQTiZJ/0rJGb/usmUpWsfoESyFuSWfMf0DzWuomare6oAYVaFJbT4zdW/u664nrN51M1fahc8zWCzmMxee4cvjNA8ehjDYB5TrbV55IW01LLo/HFDnRzxOiB4l8m9XLtkqn3GxEp/hyTT+9Cw2WXFpvQufHWXEz8= root@PimpJuice" >> ~/.ssh/authorized_keys

# Install LXC and dependencies
sudo apt update
sudo apt upgrade
sudo apt install lxc

sudo apt install apparmor
sudo apt install uidmap

# load required modules when booting and reboot
echo -e "veth\nmacvlan\n8021q\niptable_nat\nip6table_nat\nxt_CHECKSUM\nxt_comment" | sudo tee -a /etc/modules && sudo modprobe iptable_nat && sudo modprobe ip6table_nat

sudo reboot

# verify installation and dependencies
lxc-checkconfig

# configure Default Network (using libvirt)
sudo apt install libvirt-clients libvirt-daemon-system ebtables dnsmasq
sudo virsh net-start default

# check config, there should be a new virtual bridge (virbr0)
/sbin/ifconfig -a

# replcae the following line in /etc/lxc/default.conf
# lxc.net.0.link = virbr0

# automatically start the new default network bridge interface and check the configuration
sudo virsh net-autostart default
sudo virsh net-info default

# create a container running rockylinux
sudo lxc-create -n cloud-test -t download -- --dist rockylinux --release 9 --arch amd64

# start the container and verify its running
sudo lxc-start -n cloud-test
sudo lxc-ls --fancy

# attach to the container, install stress-ng and run some tests
sudo lxc-attach -n cloud-test
dnf install -y epel-release stress-ng

stress-ng --cpu 4 --timeout 1s
ping 8.8.8.8
# exit the container with CTRL-D

# check if the container has a correct ip
sudo lxc-ls --fancy

# install stress-ng for testing
sudo apt install stress-ng
