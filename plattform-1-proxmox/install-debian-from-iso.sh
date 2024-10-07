# Download the iso
cd /var/lib/vz/template/iso
sudo wget https://get.debian.org/images/archive/12.5.0/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso

# Install the Proxmox cli
sudo apt install proxmox-ve

# Create the VM using the Proxmox cli tool
sudo qm create 100 \
    --name Debian-VM \
    --memory 512 \
    --balloon 2048 \
    --cores 1 \
    --net0 virtio,bridge=vmbr0 \
    --bootdisk scsi0 \
    --scsihw virtio-scsi-pci \
    --ide2 local:iso/debian-12.5.0-amd64-netinst.iso,media=cdrom \
    --ostype l26 \
    --agent 1 \
    --sockets 1

# Create the virtual disk
sudo qm set 100 --scsi0 local:4,format=qcow2

# Start the vm
sudo qm start 100

# go to the web dashboard for the rest of the configuration

# After the instalation you have to remove the iso and set the boot disk.
# Before theese changes take effect you have to completely shut down the VM once.
sudo qm set 100 --ide2 none
sudo qm set 100 --boot order=scsi0

# After that start and attach to the VM from your terminal
sudo qm start 100
sudo qm terminal 100 # TODO: fix unable to find serial interface

