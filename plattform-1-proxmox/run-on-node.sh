# TODO Add the SSH key of our prof

# See this link for more information about this part of the script
# https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_12_Bookworm#Install_Proxmox_VE

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
