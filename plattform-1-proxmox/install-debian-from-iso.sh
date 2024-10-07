# Download the iso
cd /var/lib/vz/template/iso
sudo wget https://get.debian.org/images/archive/12.5.0/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso

# Install the Proxmox cli
sudo apt install proxmox-ve

# -------------------------------------------------------------------------- #
# Note: you can also configure the VM in the Web interface! (probaly easier) #
# -------------------------------------------------------------------------- #

# Create the VM using the Proxmox cli tool
sudo qm create 100 --name Debian-VM --memory 512 --balloon 2048 --cores 1 --net0 virtio,bridge=vmbr0 --bootdisk scsi0 --scsihw virtio-scsi-pci --ide2 local:iso/debian-12.5.0-amd64-netinst.iso,media=cdrom --ostype l26 --agent 1 --sockets 1
sudo qm set 100 --scsi0 local-lvm:10

# Start the vm
sudo qm start 100

# sudo qm terminal 100
# go to the web dashboard for the rest of the configuration

# remove the boot iso
sudo qm stop 100

# removing the boot disk
sudo qm set 100 --ide2 none

