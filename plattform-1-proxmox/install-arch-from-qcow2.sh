# Download the iso
# maybe you have to create the directory first with suod mkdir
cd /var/lib/vz/template/qcow2
sudo wget https://geo.mirror.pkgbuild.com/images/v20240915.263127/Arch-Linux-x86_64-cloudimg.qcow2

# Install the Proxmox cli
sudo apt install proxmox-ve

# Create the VM using the Proxmox cli tool
sudo qm create 101 --name Arch-Linux-VM --memory 512 --balloon 2048 --cores 1 --net0 virtio,bridge=vmbr0 --ostype l26 --agent 1 --sockets 1

# import the qcow image
sudo qm importdisk 101 /var/lib/vz/template/qcow2/Arch-Linux-x86_64-cloudimg.qcow2 local-lvm

# attach the imported disk
sudo qm set 101 --scsi0 local:vm-101-disk-0      # Does not work properly yet

# add cloud-init for access
sudo qm set 101 --ide2 local-lvm:cloudinit       # Not sure if needed
sudo qm set 101 --ipconfig0 ip=dhcp              # Not sure if needed
sudo qm set 101 --ciuser user --cipassword pass

# start the VM
sudo qm start 101


