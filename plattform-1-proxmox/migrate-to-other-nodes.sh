# check if the VMs exists and ids are correct
sudo qm list

# make sure the VMs are stopped
sudo qm stop 100
sudo qm stop 101

# create the clones of the VMs for the other nodes
sudo qm clone 100 200 --name Debian-VM-2 --full true
sudo qm clone 101 201 --name Arch-VM-2 --full true
sudo qm clone 100 300 --name Debian-VM-3 --full true
sudo qm clone 101 301 --name Arch-VM-3 --full true

# make sure all VMs are started
sudo qm start 100
sudo qm start 101
sudo qm start 200
sudo qm start 201
sudo qm start 300
sudo qm start 301

# migrate the VMs to its respective nodes
sudo qm migrate 200 node02 --online --with-local-disks
sudo qm migrate 201 node02 --online --with-local-disks
sudo qm migrate 300 node03 --online --with-local-disks
sudo qm migrate 301 node03 --online --with-local-disks

# enable High Availability
sudo ha-manager add vm:100
sudo ha-manager add vm:101
sudo ha-manager add vm:200
sudo ha-manager add vm:201
sudo ha-manager add vm:300
sudo ha-manager add vm:301

# check ha status
sudo ha-manager status
