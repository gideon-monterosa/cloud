# Add shanes ssh key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtMSm3Vi0ReI7Bv6vJCv6d4XjCobQ2MebIWk1rmKrP1aZInVoU+Z5NUVKn/Ze4Gqs0wjvbVBTVBaGBG+1z/DJRDmyqHqJ29lSvGfQqsXenTs5LqnXYHaNFUbqrxcWBGmYOcRjbWx+1tIFOs/LRFfM+74HJcCcVde6L6T3DLB6HsWrtnTDDXDoTJbxNVzjDcmft6bxvm3mS3L8ZHpmcgKVQLdlQLTfCXsXJzZyRQ37Bc1hc1c/t7KEphGgzpAr0BM+t/Rffcqq57gyrIfLseb1PIPTwJ1qjePcAhchvVV4YsbtFJJb9JMX6rqi+t9NnlXuCwXF8ulZaTaJ7UkijQqjw78m7jLz2eQaMQTiZJ/0rJGb/usmUpWsfoESyFuSWfMf0DzWuomare6oAYVaFJbT4zdW/u664nrN51M1fahc8zWCzmMxee4cvjNA8ehjDYB5TrbV55IW01LLo/HFDnRzxOiB4l8m9XLtkqn3GxEp/hyTT+9Cw2WXFpvQufHWXEz8= root@PimpJuice" >> ~/.ssh/authorized_keys

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
#switch to eval user
sudo su eval

# create and Add ssh key to evalUser authorized_keys file
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys


# k3s auf dem k3snode01 installieren (master)
sudo apt update && sudo apt upgrade -y

curl -sfL https://get.k3s.io | sh -s - server

# validate the installation
sudo systemctl status k3s
sudo k3s kubectl get nodes

# kopiere den token
sudo cat /var/lib/rancher/k3s/server/node-token

# k3s auf dem k3snode02 installieren (agent)
sudo apt update && sudo apt upgrade -y

curl -sfL https://get.k3s.io | K3S_URL=https://86.119.44.24:6443 K3S_TOKEN=TOKEN sh - # TOKEN durch den token ersetzen

# validate the installation
sudo systemctl status k3s-agent

# validate on the master
sudo k3s kubectl get nodes

# Tain auf dem master einrichten
sudo k3s kubectl taint node k3snode01 k3s-controlplane=true:NoSchedule
sudo k3s kubectl get nodes -o wide
sudo k3s kubectl describe node k3snode01 | grep Taints

# example workload ausführen
sudo k3s kubectl create deployment hello-node --image=registry.k8s.io/echoserver:1.4
sudo k3s kubectl get deployments
sudo k3s kubectl get pods -o wide

# Reschedule der workload
sudo k3s kubectl get pods
sudo k3s kubectl delete pod pod-name # pod-name durch den pod name ersetzen
sudo k3s kubectl get pods -o wide

